import 'package:equatable/equatable.dart';

import 'exercise.dart';
import 'exercise_target_type.dart';

/// The values captured by the add/edit exercise form, before they become a
/// full [Exercise] with identity, position, and completion state.
class ExerciseDraft extends Equatable {
  const ExerciseDraft({
    required this.name,
    required this.category,
    required this.targetType,
    required this.sets,
    this.repetitions,
    this.durationSeconds,
  });

  final String name;
  final String category;
  final ExerciseTargetType targetType;
  final int sets;
  final int? repetitions;
  final int? durationSeconds;

  /// Builds the exercise this draft describes. The caller supplies identity
  /// and position so edits preserve them and additions get fresh values.
  Exercise toExercise({
    required String id,
    required int order,
    bool isCompleted = false,
    int completedSets = 0,
  }) {
    final bool countsRepetitions = targetType == ExerciseTargetType.repetitions;
    return Exercise(
      id: id,
      name: name.trim(),
      category: category.trim(),
      targetType: targetType,
      sets: sets,
      repetitions: countsRepetitions ? repetitions : null,
      durationSeconds: countsRepetitions ? null : durationSeconds,
      isCompleted: isCompleted,
      order: order,
      completedSets: completedSets.clamp(0, sets),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    category,
    targetType,
    sets,
    repetitions,
    durationSeconds,
  ];
}
