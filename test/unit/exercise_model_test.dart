import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/models/exercise_target_type.dart';
import 'package:train_in_blue/data/models/workout_snapshot.dart';

Map<String, dynamic> validJson({Map<String, dynamic>? overrides}) {
  return <String, dynamic>{
    'id': 'ex-1',
    'name': 'Squat',
    'category': 'Legs',
    'targetType': 'repetitions',
    'sets': 3,
    'repetitions': 12,
    'isCompleted': false,
    'order': 0,
    ...?overrides,
  };
}

void main() {
  group('Exercise JSON', () {
    test('repetition exercise round-trips through JSON unchanged', () {
      final Exercise original = Exercise.fromJson(validJson());
      final Exercise restored = Exercise.fromJson(original.toJson());

      expect(restored, original);
      expect(restored.targetType, ExerciseTargetType.repetitions);
      expect(restored.repetitions, 12);
      expect(restored.durationSeconds, isNull);
    });

    test('duration exercise round-trips through JSON unchanged', () {
      final Exercise original = Exercise.fromJson(
        validJson(
          overrides: <String, dynamic>{
            'targetType': 'duration',
            'durationSeconds': 45,
            'repetitions': null,
            'isCompleted': true,
          },
        ),
      );
      final Exercise restored = Exercise.fromJson(original.toJson());

      expect(restored, original);
      expect(restored.targetType, ExerciseTargetType.duration);
      expect(restored.durationSeconds, 45);
      expect(restored.repetitions, isNull);
      expect(restored.isCompleted, isTrue);
    });

    test('rejects blank name and category', () {
      expect(
        () => Exercise.fromJson(
          validJson(overrides: <String, dynamic>{'name': '  '}),
        ),
        throwsFormatException,
      );
      expect(
        () => Exercise.fromJson(
          validJson(overrides: <String, dynamic>{'category': ''}),
        ),
        throwsFormatException,
      );
    });

    test('rejects non-positive sets and unknown target types', () {
      expect(
        () => Exercise.fromJson(
          validJson(overrides: <String, dynamic>{'sets': 0}),
        ),
        throwsFormatException,
      );
      expect(
        () => Exercise.fromJson(
          validJson(overrides: <String, dynamic>{'targetType': 'distance'}),
        ),
        throwsFormatException,
      );
    });

    test('rejects a missing or invalid value for the selected target', () {
      expect(
        () => Exercise.fromJson(
          validJson(overrides: <String, dynamic>{'repetitions': null}),
        ),
        throwsFormatException,
      );
      expect(
        () => Exercise.fromJson(
          validJson(
            overrides: <String, dynamic>{
              'targetType': 'duration',
              'durationSeconds': -5,
            },
          ),
        ),
        throwsFormatException,
      );
    });

    test('only requires the selected target type', () {
      final Exercise exercise = Exercise.fromJson(
        validJson(overrides: <String, dynamic>{'durationSeconds': null}),
      );

      expect(exercise.repetitions, 12);
      expect(exercise.durationSeconds, isNull);
    });

    test('defaults completedSets to zero and round-trips progress', () {
      final Exercise withoutProgress = Exercise.fromJson(validJson());
      expect(withoutProgress.completedSets, 0);

      final Exercise withProgress = Exercise.fromJson(
        validJson(overrides: <String, dynamic>{'completedSets': 2}),
      );
      expect(withProgress.completedSets, 2);
      expect(
        Exercise.fromJson(withProgress.toJson()).completedSets,
        2,
      );
    });

    test('clamps completedSets to the configured set count', () {
      final Exercise exercise = Exercise.fromJson(
        validJson(overrides: <String, dynamic>{'completedSets': 99}),
      );
      expect(exercise.completedSets, 3);
    });
  });

  group('WorkoutSnapshot JSON', () {
    test('round-trips and sorts exercises by explicit order', () {
      final WorkoutSnapshot snapshot = WorkoutSnapshot.fromJson(
        <String, dynamic>{
          'schemaVersion': 1,
          'updatedAt': '2026-07-14T10:00:00.000',
          'exercises': <Map<String, dynamic>>[
            validJson(overrides: <String, dynamic>{'id': 'second', 'order': 1}),
            validJson(overrides: <String, dynamic>{'id': 'first', 'order': 0}),
          ],
        },
      );

      expect(snapshot.exercises.first.id, 'first');
      expect(snapshot.exercises.last.id, 'second');

      final WorkoutSnapshot restored = WorkoutSnapshot.fromJson(
        snapshot.toJson(),
      );
      expect(restored, snapshot);
    });

    test('rejects unsupported schema versions and malformed payloads', () {
      expect(
        () => WorkoutSnapshot.fromJson(const <String, dynamic>{
          'schemaVersion': 99,
          'exercises': <Object>[],
        }),
        throwsFormatException,
      );
      expect(
        () => WorkoutSnapshot.fromJson(const <String, dynamic>{
          'schemaVersion': 1,
          'exercises': 'not-a-list',
        }),
        throwsFormatException,
      );
    });
  });
}
