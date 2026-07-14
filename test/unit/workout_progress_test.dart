import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Core/Utils/daypart.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/models/workout_progress.dart';

import '../helpers/fake_repositories.dart';

void main() {
  group('WorkoutProgress', () {
    test('empty workout reports zero progress without dividing by zero', () {
      final WorkoutProgress progress = WorkoutProgress.fromExercises(
        const <Exercise>[],
      );

      expect(progress.totalCount, 0);
      expect(progress.completedCount, 0);
      expect(progress.remainingCount, 0);
      expect(progress.fraction, 0);
      expect(progress.percent, 0);
      expect(progress.isComplete, isFalse);
    });

    test('partial workout derives counts, remaining, and percentage', () {
      final WorkoutProgress progress = WorkoutProgress.fromExercises(<Exercise>[
        buildExercise(id: 'a', order: 0, isCompleted: true),
        buildExercise(id: 'b', order: 1, isCompleted: true),
        buildExercise(id: 'c', order: 2),
        buildExercise(id: 'd', order: 3),
        buildExercise(id: 'e', order: 4),
      ]);

      expect(progress.completedCount, 2);
      expect(progress.totalCount, 5);
      expect(progress.remainingCount, 3);
      expect(progress.percent, 40);
      expect(progress.isComplete, isFalse);
    });

    test('rounds percentage to the nearest whole number', () {
      final WorkoutProgress progress = WorkoutProgress.fromExercises(<Exercise>[
        buildExercise(id: 'a', order: 0, isCompleted: true),
        buildExercise(id: 'b', order: 1),
        buildExercise(id: 'c', order: 2),
      ]);

      expect(progress.percent, 33);
    });

    test('fully completed workout reports 100% and isComplete', () {
      final WorkoutProgress progress = WorkoutProgress.fromExercises(<Exercise>[
        buildExercise(id: 'a', order: 0, isCompleted: true),
        buildExercise(id: 'b', order: 1, isCompleted: true),
      ]);

      expect(progress.percent, 100);
      expect(progress.remainingCount, 0);
      expect(progress.isComplete, isTrue);
    });

    test('phase follows the session: start, middle, last one, done', () {
      WorkoutProgress at(int completed, int total) =>
          WorkoutProgress(completedCount: completed, totalCount: total);

      expect(WorkoutProgress.empty.phase, WorkoutPhase.notStarted);
      expect(at(0, 4).phase, WorkoutPhase.notStarted);
      expect(at(1, 4).phase, WorkoutPhase.inProgress);
      expect(at(3, 4).phase, WorkoutPhase.almostDone);
      expect(at(4, 4).phase, WorkoutPhase.complete);
    });
  });

  group('Daypart', () {
    test('maps hours to morning, afternoon, and evening', () {
      expect(Daypart.of(DateTime(2026, 7, 14, 7)), Daypart.morning);
      expect(Daypart.of(DateTime(2026, 7, 14, 11, 59)), Daypart.morning);
      expect(Daypart.of(DateTime(2026, 7, 14, 12)), Daypart.afternoon);
      expect(Daypart.of(DateTime(2026, 7, 14, 16, 59)), Daypart.afternoon);
      expect(Daypart.of(DateTime(2026, 7, 14, 17)), Daypart.evening);
      expect(Daypart.of(DateTime(2026, 7, 14, 23)), Daypart.evening);
    });
  });
}
