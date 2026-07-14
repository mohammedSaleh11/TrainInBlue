import 'package:equatable/equatable.dart';

import '../../data/models/exercise.dart';
import '../../data/models/workout_progress.dart';

/// The four explicit situations the workout UI can be in.
enum WorkoutStatus { loading, ready, empty, failure }

/// Why loading the workout failed; the UI maps each reason to friendly copy
/// and recovery actions.
enum WorkoutFailureReason {
  corruptSavedWorkout,
  starterDataInvalid,
  storageFailure,
}

/// Immutable snapshot of everything the workout screens render.
///
/// Status, exercises, and progress are always derived together, so the UI can
/// never show numbers that disagree with the list.
class WorkoutState extends Equatable {
  const WorkoutState._({
    required this.status,
    this.exercises = const <Exercise>[],
    this.progress = WorkoutProgress.empty,
    this.failureReason,
    this.hasPendingSaveFailure = false,
    this.celebrationPending = false,
  });

  const WorkoutState.loading() : this._(status: WorkoutStatus.loading);

  /// A live session; empty exercise lists become [WorkoutStatus.empty].
  factory WorkoutState.session(
    List<Exercise> exercises, {
    bool hasPendingSaveFailure = false,
    bool celebrationPending = false,
  }) {
    return WorkoutState._(
      status: exercises.isEmpty ? WorkoutStatus.empty : WorkoutStatus.ready,
      exercises: List<Exercise>.unmodifiable(exercises),
      progress: WorkoutProgress.fromExercises(exercises),
      hasPendingSaveFailure: hasPendingSaveFailure,
      celebrationPending: celebrationPending,
    );
  }

  const WorkoutState.failure(WorkoutFailureReason reason)
    : this._(status: WorkoutStatus.failure, failureReason: reason);

  final WorkoutStatus status;
  final List<Exercise> exercises;
  final WorkoutProgress progress;
  final WorkoutFailureReason? failureReason;

  /// True when the most recent save attempt failed; the session stays usable
  /// and the UI offers a retry.
  final bool hasPendingSaveFailure;

  /// One-shot flag raised when the final exercise was just completed.
  final bool celebrationPending;

  bool get hasSession =>
      status == WorkoutStatus.ready || status == WorkoutStatus.empty;

  /// The exercise with [id], or null once it has been deleted.
  Exercise? exerciseById(String id) {
    for (final Exercise exercise in exercises) {
      if (exercise.id == id) {
        return exercise;
      }
    }
    return null;
  }

  WorkoutState copyWith({
    bool? hasPendingSaveFailure,
    bool? celebrationPending,
  }) {
    return WorkoutState._(
      status: status,
      exercises: exercises,
      progress: progress,
      failureReason: failureReason,
      hasPendingSaveFailure:
          hasPendingSaveFailure ?? this.hasPendingSaveFailure,
      celebrationPending: celebrationPending ?? this.celebrationPending,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    status,
    exercises,
    progress,
    failureReason,
    hasPendingSaveFailure,
    celebrationPending,
  ];
}
