import 'package:equatable/equatable.dart';

import 'exercise.dart';

/// The whole persisted workout: schema version, update timestamp, and every
/// exercise with its order and completion state. Saved atomically as one
/// JSON document after each successful mutation.
class WorkoutSnapshot extends Equatable {
  const WorkoutSnapshot({
    required this.schemaVersion,
    required this.updatedAt,
    required this.exercises,
  });

  /// Parses a persisted snapshot; throws [FormatException] when the payload
  /// is corrupt or written by an unsupported future schema.
  factory WorkoutSnapshot.fromJson(Map<String, dynamic> json) {
    final Object? version = json['schemaVersion'];
    if (version is! int || version < 1 || version > currentSchemaVersion) {
      throw FormatException('Unsupported workout schema version: $version');
    }
    final Object? rawExercises = json['exercises'];
    if (rawExercises is! List) {
      throw const FormatException('Workout payload has no exercise list.');
    }
    final List<Exercise> exercises = rawExercises
        .map((Object? entry) {
          if (entry is! Map<String, dynamic>) {
            throw const FormatException('Exercise entry is not an object.');
          }
          return Exercise.fromJson(entry);
        })
        .toList(growable: false);
    return WorkoutSnapshot(
      schemaVersion: version,
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      exercises: sortedByOrder(exercises),
    );
  }

  static const int currentSchemaVersion = 1;

  final int schemaVersion;
  final DateTime updatedAt;
  final List<Exercise> exercises;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'schemaVersion': schemaVersion,
      'updatedAt': updatedAt.toIso8601String(),
      'exercises': exercises
          .map((Exercise exercise) => exercise.toJson())
          .toList(growable: false),
    };
  }

  /// Returns a copy of [exercises] sorted by their explicit order value.
  static List<Exercise> sortedByOrder(List<Exercise> exercises) {
    final List<Exercise> sorted = List<Exercise>.of(exercises)
      ..sort((Exercise a, Exercise b) => a.order.compareTo(b.order));
    return List<Exercise>.unmodifiable(sorted);
  }

  @override
  List<Object?> get props => <Object?>[schemaVersion, updatedAt, exercises];
}
