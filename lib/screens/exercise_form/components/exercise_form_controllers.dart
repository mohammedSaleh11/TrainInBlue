import 'package:flutter/material.dart';

import '../../../Core/Utils/exercise_draft_validator.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/exercise_draft.dart';
import '../../../data/models/exercise_target_type.dart';

/// Owns the add/edit form controllers and draft validity checks.
class ExerciseFormControllers {
  ExerciseFormControllers({Exercise? exercise})
    : name = TextEditingController(text: exercise?.name ?? ''),
      category = TextEditingController(text: exercise?.category ?? ''),
      sets = TextEditingController(text: exercise?.sets.toString() ?? ''),
      repetitions = TextEditingController(
        text: exercise?.repetitions?.toString() ?? '',
      ),
      duration = TextEditingController(
        text: exercise?.durationSeconds?.toString() ?? '',
      ),
      targetType = exercise?.targetType ?? ExerciseTargetType.repetitions {
    listenable = Listenable.merge(<Listenable>[
      name,
      category,
      sets,
      repetitions,
      duration,
    ]);
  }

  final TextEditingController name;
  final TextEditingController category;
  final TextEditingController sets;
  final TextEditingController repetitions;
  final TextEditingController duration;
  late final Listenable listenable;
  ExerciseTargetType targetType;

  bool get isValid {
    final String targetText = targetType == ExerciseTargetType.repetitions
        ? repetitions.text
        : duration.text;
    return ExerciseDraftValidator.validateName(name.text) == null &&
        ExerciseDraftValidator.validateCategory(category.text) == null &&
        ExerciseDraftValidator.validateSets(sets.text) == null &&
        ExerciseDraftValidator.validateTarget(targetType, targetText) == null;
  }

  ExerciseDraft toDraft() {
    final bool reps = targetType == ExerciseTargetType.repetitions;
    return ExerciseDraft(
      name: name.text,
      category: category.text,
      targetType: targetType,
      sets: int.parse(sets.text.trim()),
      repetitions: reps ? int.parse(repetitions.text.trim()) : null,
      durationSeconds: reps ? null : int.parse(duration.text.trim()),
    );
  }

  void dispose() {
    name.dispose();
    category.dispose();
    sets.dispose();
    repetitions.dispose();
    duration.dispose();
  }
}
