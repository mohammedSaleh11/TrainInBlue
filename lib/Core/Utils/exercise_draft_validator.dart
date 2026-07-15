import '../../data/models/exercise_target_type.dart';

/// Validation rules for the exercise form, kept out of widgets so the form
/// and the tests share one source of truth.
class ExerciseDraftValidator {
  ExerciseDraftValidator._();

  static const int maxNameLength = 60;
  static const int maxSets = 20;
  static const int maxRepetitions = 200;
  static const int maxDurationSeconds = 3600;

  /// All validators return null when the value is acceptable, matching the
  /// [FormFieldValidator] contract.
  static String? validateName(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Add a name for this exercise.';
    }
    if (text.length > maxNameLength) {
      return 'Keep the name under $maxNameLength characters.';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Pick a category to continue.';
    }
    return null;
  }

  static String? validateSets(String? value) {
    return _validatePositiveNumber(value, 'sets', maxSets);
  }

  static String? validateRepetitions(String? value) {
    return _validatePositiveNumber(value, 'repetitions', maxRepetitions);
  }

  static String? validateDurationSeconds(String? value) {
    return _validatePositiveNumber(value, 'seconds', maxDurationSeconds);
  }

  /// The target field that matters for [targetType]; the other is ignored.
  static String? validateTarget(ExerciseTargetType targetType, String? value) {
    return targetType == ExerciseTargetType.repetitions
        ? validateRepetitions(value)
        : validateDurationSeconds(value);
  }

  static String? _validatePositiveNumber(String? value, String label, int max) {
    final int? parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a positive number of $label.';
    }
    if (parsed > max) {
      return 'Keep $label at or below $max.';
    }
    return null;
  }
}
