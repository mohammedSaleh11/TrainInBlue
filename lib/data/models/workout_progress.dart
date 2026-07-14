import 'package:equatable/equatable.dart';

import 'exercise.dart';

/// How far along the session is, so the UI can pick copy and styling
/// without re-deriving thresholds.
enum WorkoutPhase { notStarted, inProgress, almostDone, complete }

/// Progress derived from the exercise list in exactly one place, so every
/// widget renders the same numbers.
class WorkoutProgress extends Equatable {
  const WorkoutProgress({
    required this.completedCount,
    required this.totalCount,
  });

  factory WorkoutProgress.fromExercises(List<Exercise> exercises) {
    return WorkoutProgress(
      completedCount: exercises
          .where((Exercise exercise) => exercise.isCompleted)
          .length,
      totalCount: exercises.length,
    );
  }

  static const WorkoutProgress empty = WorkoutProgress(
    completedCount: 0,
    totalCount: 0,
  );

  final int completedCount;
  final int totalCount;

  int get remainingCount => totalCount - completedCount;

  /// Safe for empty workouts: 0.0 instead of a division by zero.
  double get fraction => totalCount == 0 ? 0 : completedCount / totalCount;

  int get percent => (fraction * 100).round();

  bool get isComplete => totalCount > 0 && completedCount == totalCount;

  WorkoutPhase get phase {
    if (isComplete) {
      return WorkoutPhase.complete;
    }
    if (completedCount == 0) {
      return WorkoutPhase.notStarted;
    }
    return remainingCount == 1
        ? WorkoutPhase.almostDone
        : WorkoutPhase.inProgress;
  }

  @override
  List<Object?> get props => <Object?>[completedCount, totalCount];
}
