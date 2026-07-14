import 'package:equatable/equatable.dart';

import 'exercise_target_type.dart';

/// A single exercise in the workout session.
///
/// Instances are immutable; mutations create copies so state changes stay
/// predictable and easy to persist atomically.
class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.targetType,
    required this.sets,
    required this.order,
    this.repetitions,
    this.durationSeconds,
    this.isCompleted = false,
    this.completedSets = 0,
  });

  /// Parses persisted or bundled JSON.
  ///
  /// Throws [FormatException] for missing or invalid values so callers can
  /// show a recovery path instead of rendering broken data.
  factory Exercise.fromJson(Map<String, dynamic> json) {
    final int sets = _requirePositiveInt(json, 'sets');
    final Exercise exercise = Exercise(
      id: _requireText(json, 'id'),
      name: _requireText(json, 'name'),
      category: _requireText(json, 'category'),
      targetType: ExerciseTargetType.fromJsonKey(json['targetType']),
      sets: sets,
      repetitions: _optionalPositiveInt(json, 'repetitions'),
      durationSeconds: _optionalPositiveInt(json, 'durationSeconds'),
      isCompleted: json['isCompleted'] == true,
      order: _requireInt(json, 'order'),
      completedSets: _optionalNonNegativeInt(json, 'completedSets').clamp(
        0,
        sets,
      ),
    );
    if (exercise.targetValue == null) {
      throw FormatException(
        'Exercise "${exercise.name}" is missing a positive '
        '${exercise.targetType.jsonKey} value.',
      );
    }
    return exercise;
  }

  final String id;
  final String name;
  final String category;
  final ExerciseTargetType targetType;
  final int sets;
  final int? repetitions;
  final int? durationSeconds;
  final bool isCompleted;
  final int order;
  final int completedSets;

  /// The value of the selected target type, or null when it is missing.
  int? get targetValue => targetType == ExerciseTargetType.repetitions
      ? repetitions
      : durationSeconds;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'targetType': targetType.jsonKey,
      'sets': sets,
      if (repetitions != null) 'repetitions': repetitions,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      'isCompleted': isCompleted,
      'order': order,
      'completedSets': completedSets,
    };
  }

  Exercise copyWith({
    bool? isCompleted,
    int? order,
    int? completedSets,
  }) {
    final int nextSets = sets;
    return Exercise(
      id: id,
      name: name,
      category: category,
      targetType: targetType,
      sets: nextSets,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      order: order ?? this.order,
      completedSets: (completedSets ?? this.completedSets).clamp(0, nextSets),
    );
  }

  static String _requireText(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    throw FormatException('Exercise field "$key" must be a non-empty string.');
  }

  static int _requireInt(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is int) {
      return value;
    }
    throw FormatException('Exercise field "$key" must be a whole number.');
  }

  static int _requirePositiveInt(Map<String, dynamic> json, String key) {
    final int value = _requireInt(json, key);
    if (value <= 0) {
      throw FormatException('Exercise field "$key" must be positive.');
    }
    return value;
  }

  static int? _optionalPositiveInt(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is int && value > 0) {
      return value;
    }
    return null;
  }

  static int _optionalNonNegativeInt(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is int && value >= 0) {
      return value;
    }
    return 0;
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    category,
    targetType,
    sets,
    repetitions,
    durationSeconds,
    isCompleted,
    order,
    completedSets,
  ];
}
