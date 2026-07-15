import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Core/Utils/exercise_id_generator.dart';
import '../../Core/errors/app_exceptions.dart';
import '../../data/models/active_exercise_timer.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_draft.dart';
import '../../data/models/exercise_target_type.dart';
import '../../data/models/workout_progress.dart';
import '../../data/repositories/workout_repository.dart';
import 'exercise_timer_engine.dart';
import 'workout_state.dart';

/// The single source of truth for the active workout session.
///
/// Owns loading, every mutation, persistence, and error handling. Widgets
/// only render [WorkoutState] and dispatch intent; they never touch storage.
class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit({
    required WorkoutRepository repository,
    ExerciseIdGenerator? idGenerator,
  }) : _repository = repository,
       _idGenerator = idGenerator ?? ExerciseIdGenerator(),
       super(const WorkoutState.loading()) {
    _timers = ExerciseTimerEngine(
      onChanged: _onTimersChanged,
      onSetCompleted: _onTimerSetCompleted,
    );
  }

  final WorkoutRepository _repository;
  final ExerciseIdGenerator _idGenerator;
  late final ExerciseTimerEngine _timers;

  /// Loads the saved workout (or seeds starter data on first launch).
  Future<void> loadWorkout() async {
    _timers.reset(notify: false);
    emit(const WorkoutState.loading());
    try {
      final List<Exercise> exercises = await _repository.loadWorkout();
      _emitSafely(WorkoutState.session(exercises));
    } on AppException catch (exception) {
      _emitSafely(WorkoutState.failure(_reasonFor(exception)));
    }
  }

  /// Recovery action: begin with an empty workout and persist that choice.
  Future<void> startEmpty() async {
    _timers.reset(notify: false);
    await _commitSession(const <Exercise>[]);
  }

  /// Restores the bundled starter workout with all exercises incomplete.
  Future<void> resetWorkout() async {
    try {
      final List<Exercise> starterExercises = await _repository
          .loadStarterExercises();
      final List<Exercise> incomplete = starterExercises
          .map(
            (Exercise exercise) =>
                exercise.copyWith(isCompleted: false, completedSets: 0),
          )
          .toList(growable: false);
      _timers.reset(notify: false);
      await _commitSession(incomplete);
    } on AppException catch (exception) {
      _emitSafely(WorkoutState.failure(_reasonFor(exception)));
    }
  }

  /// Adds a new exercise at the end of the session, incomplete.
  Future<void> addExercise(ExerciseDraft draft) async {
    final Exercise added = draft.toExercise(
      id: _idGenerator.nextId(),
      order: state.exercises.length,
    );
    await _commitSession(<Exercise>[...state.exercises, added]);
  }

  /// Applies edited values while preserving id, position, and completion.
  Future<void> updateExercise(String id, ExerciseDraft draft) async {
    final List<Exercise> updated = state.exercises
        .map(
          (Exercise exercise) => exercise.id == id
              ? draft.toExercise(
                  id: exercise.id,
                  order: exercise.order,
                  isCompleted: exercise.isCompleted,
                  completedSets: exercise.completedSets.clamp(0, draft.sets),
                )
              : exercise,
        )
        .toList(growable: false);
    if (draft.targetType != ExerciseTargetType.duration ||
        draft.durationSeconds == null) {
      _timers.clear(id);
    } else {
      final ActiveExerciseTimer? current = state.timerFor(id);
      if (current == null ||
          current.totalSeconds != draft.durationSeconds) {
        _timers.resetIdle(
          exerciseId: id,
          totalSeconds: draft.durationSeconds!,
        );
      }
    }
    await _commitSession(updated);
  }

  Future<void> deleteExercise(String id) async {
    _timers.clear(id);
    final List<Exercise> remaining = state.exercises
        .where((Exercise exercise) => exercise.id != id)
        .toList(growable: false);
    await _commitSession(remaining);
  }

  /// Moves an exercise using raw [ReorderableListView] indices.
  Future<void> reorderExercise(int oldIndex, int newIndex) async {
    final List<Exercise> reordered = List<Exercise>.of(state.exercises);
    final int insertionIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final Exercise moved = reordered.removeAt(oldIndex);
    reordered.insert(insertionIndex, moved);
    await _commitSession(reordered);
  }

  /// Completes an incomplete exercise or reopens a completed one.
  Future<void> toggleCompletion(String id) async {
    final bool wasSessionComplete = state.progress.isComplete;
    final List<Exercise> toggled = state.exercises
        .map(
          (Exercise exercise) => exercise.id == id
              ? exercise.copyWith(isCompleted: !exercise.isCompleted)
              : exercise,
        )
        .toList(growable: false);
    final bool isSessionComplete = WorkoutProgress.fromExercises(
      toggled,
    ).isComplete;
    await _commitSession(
      toggled,
      celebrationPending: !wasSessionComplete && isSessionComplete,
    );
  }

  /// Records how many sets are finished for an exercise.
  Future<void> trackCompletedSets(String id, int completedSets) async {
    final Exercise? exercise = state.exerciseById(id);
    final List<Exercise> updated = state.exercises
        .map(
          (Exercise item) => item.id == id
              ? item.copyWith(
                  completedSets: completedSets.clamp(0, item.sets),
                )
              : item,
        )
        .toList(growable: false);
    if (exercise != null &&
        exercise.targetType == ExerciseTargetType.duration &&
        exercise.durationSeconds != null) {
      _timers.resetIdle(
        exerciseId: id,
        totalSeconds: exercise.durationSeconds!,
      );
    }
    await _commitSession(updated);
  }

  /// Ensures a duration timer exists for [exerciseId] (idle at full duration).
  void ensureTimer({
    required String exerciseId,
    required int totalSeconds,
  }) {
    _timers.ensure(exerciseId: exerciseId, totalSeconds: totalSeconds);
  }

  /// Starts, pauses, or resumes the countdown for a duration exercise.
  void toggleTimer({
    required String exerciseId,
    required int totalSeconds,
  }) {
    _timers.toggle(exerciseId: exerciseId, totalSeconds: totalSeconds);
  }

  /// Restarts the current set countdown and starts it immediately.
  void restartTimer({
    required String exerciseId,
    required int totalSeconds,
  }) {
    _timers.restart(exerciseId: exerciseId, totalSeconds: totalSeconds);
  }

  /// Retries persisting the current session after a failed save.
  Future<void> retrySave() async {
    if (!state.hasSession) {
      return;
    }
    await _persistCurrent(state.exercises);
  }

  /// Marks the completion celebration as shown so it never repeats.
  void acknowledgeCelebration() {
    emit(state.copyWith(celebrationPending: false));
  }

  @override
  Future<void> close() {
    _timers.dispose();
    return super.close();
  }

  void _onTimersChanged(Map<String, ActiveExerciseTimer> timers) {
    if (!state.hasSession) {
      return;
    }
    _emitSafely(state.copyWith(activeTimers: timers));
  }

  /// Persists a finished duration set as soon as the countdown hits zero.
  void _onTimerSetCompleted(String exerciseId) {
    final Exercise? exercise = state.exerciseById(exerciseId);
    if (exercise == null ||
        exercise.targetType != ExerciseTargetType.duration ||
        exercise.completedSets >= exercise.sets) {
      return;
    }
    unawaited(
      trackCompletedSets(exerciseId, exercise.completedSets + 1),
    );
  }

  /// Emits the new session optimistically, then persists it atomically.
  /// A failed save keeps the session usable and raises the retry flag.
  Future<void> _commitSession(
    List<Exercise> exercises, {
    bool celebrationPending = false,
  }) async {
    final List<Exercise> normalized = _normalizeOrder(exercises);
    _timers.retainOnly(
      normalized.map((Exercise exercise) => exercise.id).toSet(),
    );
    _emitSafely(
      WorkoutState.session(
        normalized,
        celebrationPending: celebrationPending,
        activeTimers: _timers.snapshot,
        hasPendingSaveFailure: state.hasPendingSaveFailure,
      ),
    );
    await _persistCurrent(normalized);
  }

  Future<void> _persistCurrent(List<Exercise> exercises) async {
    try {
      await _repository.saveWorkout(exercises);
      if (state.hasPendingSaveFailure) {
        _emitSafely(state.copyWith(hasPendingSaveFailure: false));
      }
    } on AppException {
      if (!state.hasPendingSaveFailure) {
        _emitSafely(state.copyWith(hasPendingSaveFailure: true));
      }
    }
  }

  /// Rewrites order values to match list positions, preserving IDs and
  /// completion states.
  List<Exercise> _normalizeOrder(List<Exercise> exercises) {
    return List<Exercise>.generate(
      exercises.length,
      (int index) => exercises[index].copyWith(order: index),
      growable: false,
    );
  }

  void _emitSafely(WorkoutState next) {
    if (!isClosed) {
      emit(next);
    }
  }

  WorkoutFailureReason _reasonFor(AppException exception) {
    return switch (exception) {
      CorruptSavedWorkoutException() =>
        WorkoutFailureReason.corruptSavedWorkout,
      StarterDataException() => WorkoutFailureReason.starterDataInvalid,
      StorageReadException() ||
      StorageWriteException() => WorkoutFailureReason.storageFailure,
    };
  }
}
