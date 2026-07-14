/// How an exercise measures effort: counted repetitions or a timed hold.
enum ExerciseTargetType {
  repetitions('repetitions', 'Repetitions'),
  duration('duration', 'Duration');

  const ExerciseTargetType(this.jsonKey, this.label);

  /// Stable value used in persisted JSON.
  final String jsonKey;

  /// Human-readable label shown in the UI.
  final String label;

  /// Parses a persisted value; throws [FormatException] for unknown values so
  /// callers can surface a recovery path instead of guessing.
  static ExerciseTargetType fromJsonKey(Object? value) {
    for (final ExerciseTargetType type in values) {
      if (type.jsonKey == value) {
        return type;
      }
    }
    throw FormatException('Unknown exercise target type: $value');
  }
}
