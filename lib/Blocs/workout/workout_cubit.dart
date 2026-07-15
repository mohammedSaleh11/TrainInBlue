import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Core/Utils/exercise_id_generator.dart';
import '../../Core/errors/app_exceptions.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_draft.dart';
import '../../data/models/workout_progress.dart';
import '../../data/repositories/workout_repository.dart';
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
       super(const WorkoutState.loading());

  final WorkoutRepository _repository;
  final ExerciseIdGenerator _idGenerator;

  /// Loads the saved workout (or seeds starter data on first launch).
  Future<void> loadWorkout() async {
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
    await _commitSession(updated);
  }

  Future<void> deleteExercise(String id) async {
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

  /// Records how many sets are finished for a repetition exercise.
  Future<void> trackCompletedSets(String id, int completedSets) async {
    final List<Exercise> updated = state.exercises
        .map(
          (Exercise exercise) => exercise.id == id
              ? exercise.copyWith(
                  completedSets: completedSets.clamp(0, exercise.sets),
                )
              : exercise,
        )
        .toList(growable: false);
    await _commitSession(updated);
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

  /// Emits the new session optimistically, then persists it atomically.
  /// A failed save keeps the session usable and raises the retry flag.
  Future<void> _commitSession(
    List<Exercise> exercises, {
    bool celebrationPending = false,
  }) async {
    final List<Exercise> normalized = _normalizeOrder(exercises);
    _emitSafely(
      WorkoutState.session(normalized, celebrationPending: celebrationPending),
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
