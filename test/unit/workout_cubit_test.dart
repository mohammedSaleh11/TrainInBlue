import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Blocs/workout/workout_cubit.dart';
import 'package:train_in_blue/Blocs/workout/workout_state.dart';
import 'package:train_in_blue/Core/errors/app_exceptions.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/models/exercise_draft.dart';
import 'package:train_in_blue/data/models/exercise_target_type.dart';

import '../helpers/fake_repositories.dart';

const ExerciseDraft _pushUpDraft = ExerciseDraft(
  name: 'Push-up',
  category: 'Chest',
  targetType: ExerciseTargetType.repetitions,
  sets: 3,
  repetitions: 10,
);

void main() {
  group('WorkoutCubit', () {
    test(
      'loadWorkout seeds starter data on first launch and persists it',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository();
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);

        await cubit.loadWorkout();

        expect(cubit.state.status, WorkoutStatus.ready);
        expect(cubit.state.exercises, hasLength(2));
        expect(repository.savedExercises, hasLength(2));
        await cubit.close();
      },
    );

    test('addExercise appends last, incomplete, and persists', () async {
      final FakeWorkoutRepository repository = FakeWorkoutRepository();
      final WorkoutCubit cubit = WorkoutCubit(repository: repository);
      await cubit.loadWorkout();

      await cubit.addExercise(_pushUpDraft);

      final Exercise added = cubit.state.exercises.last;
      expect(added.name, 'Push-up');
      expect(added.isCompleted, isFalse);
      expect(added.order, 2);
      expect(added.id, isNotEmpty);
      expect(repository.savedExercises!.last.name, 'Push-up');
      expect(cubit.state.progress.totalCount, 3);
      await cubit.close();
    });

    test('updateExercise preserves id, order, and completion state', () async {
      final FakeWorkoutRepository repository = FakeWorkoutRepository(
        savedExercises: <Exercise>[
          buildExercise(id: 'keep', order: 0, isCompleted: true),
          buildExercise(id: 'other', order: 1),
        ],
      );
      final WorkoutCubit cubit = WorkoutCubit(repository: repository);
      await cubit.loadWorkout();

      await cubit.updateExercise('keep', _pushUpDraft);

      final Exercise updated = cubit.state.exercises.first;
      expect(updated.id, 'keep');
      expect(updated.order, 0);
      expect(updated.isCompleted, isTrue);
      expect(updated.name, 'Push-up');
      expect(repository.savedExercises!.first.name, 'Push-up');
      await cubit.close();
    });

    test('deleteExercise removes, persists, and updates progress', () async {
      final FakeWorkoutRepository repository = FakeWorkoutRepository(
        savedExercises: <Exercise>[
          buildExercise(id: 'a', order: 0, isCompleted: true),
          buildExercise(id: 'b', order: 1),
        ],
      );
      final WorkoutCubit cubit = WorkoutCubit(repository: repository);
      await cubit.loadWorkout();

      await cubit.deleteExercise('a');

      expect(cubit.state.exercises.single.id, 'b');
      expect(cubit.state.progress.completedCount, 0);
      expect(cubit.state.progress.percent, 0);
      expect(repository.savedExercises, hasLength(1));
      await cubit.close();
    });

    test('reorderExercise moves items, rewrites order, keeps states', () async {
      final FakeWorkoutRepository repository = FakeWorkoutRepository(
        savedExercises: <Exercise>[
          buildExercise(id: 'a', order: 0, isCompleted: true),
          buildExercise(id: 'b', order: 1),
          buildExercise(id: 'c', order: 2),
        ],
      );
      final WorkoutCubit cubit = WorkoutCubit(repository: repository);
      await cubit.loadWorkout();

      // Simulates dragging the first card below the last one.
      await cubit.reorderExercise(0, 3);

      final List<String> ids = cubit.state.exercises
          .map((Exercise exercise) => exercise.id)
          .toList(growable: false);
      expect(ids, <String>['b', 'c', 'a']);
      expect(cubit.state.exercises.last.isCompleted, isTrue);
      expect(
        cubit.state.exercises.map((Exercise exercise) => exercise.order),
        <int>[0, 1, 2],
      );
      expect(repository.savedExercises!.last.id, 'a');
      await cubit.close();
    });

    test('trackCompletedSets persists set progress and clamps to total sets', () async {
      final FakeWorkoutRepository repository = FakeWorkoutRepository(
        savedExercises: <Exercise>[
          buildExercise(id: 'a', order: 0, sets: 3),
        ],
      );
      final WorkoutCubit cubit = WorkoutCubit(repository: repository);
      await cubit.loadWorkout();

      await cubit.trackCompletedSets('a', 2);
      expect(cubit.state.exercises.single.completedSets, 2);
      expect(repository.savedExercises!.single.completedSets, 2);

      await cubit.trackCompletedSets('a', 99);
      expect(cubit.state.exercises.single.completedSets, 3);
      await cubit.close();
    });

    test(
      'toggleCompletion completes, reopens, and persists both ways',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository(
          savedExercises: <Exercise>[buildExercise(id: 'a', order: 0)],
        );
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);
        await cubit.loadWorkout();

        await cubit.toggleCompletion('a');
        expect(cubit.state.exercises.single.isCompleted, isTrue);
        expect(repository.savedExercises!.single.isCompleted, isTrue);

        await cubit.toggleCompletion('a');
        expect(cubit.state.exercises.single.isCompleted, isFalse);
        expect(repository.savedExercises!.single.isCompleted, isFalse);
        await cubit.close();
      },
    );

    test(
      'raises the celebration only when the final exercise completes',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository(
          savedExercises: <Exercise>[
            buildExercise(id: 'a', order: 0, isCompleted: true),
            buildExercise(id: 'b', order: 1),
          ],
        );
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);
        await cubit.loadWorkout();

        await cubit.toggleCompletion('b');
        expect(cubit.state.celebrationPending, isTrue);

        cubit.acknowledgeCelebration();
        expect(cubit.state.celebrationPending, isFalse);

        // Reopening and completing again should celebrate again; reloading
        // an already-complete workout should not.
        await cubit.toggleCompletion('b');
        expect(cubit.state.celebrationPending, isFalse);
        await cubit.loadWorkout();
        expect(cubit.state.celebrationPending, isFalse);
        await cubit.close();
      },
    );

    test(
      'resetWorkout restores starter data with all exercises incomplete',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository(
          savedExercises: <Exercise>[
            buildExercise(id: 'custom', order: 0, isCompleted: true),
          ],
        );
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);
        await cubit.loadWorkout();

        await cubit.resetWorkout();

        expect(cubit.state.exercises, hasLength(2));
        expect(
          cubit.state.exercises.every((Exercise e) => !e.isCompleted),
          isTrue,
        );
        expect(repository.savedExercises, hasLength(2));
        await cubit.close();
      },
    );

    test(
      'failed save keeps the session usable and retrySave recovers',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository();
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);
        await cubit.loadWorkout();

        repository.failNextSave = true;
        await cubit.addExercise(_pushUpDraft);

        expect(cubit.state.status, WorkoutStatus.ready);
        expect(cubit.state.exercises, hasLength(3));
        expect(cubit.state.hasPendingSaveFailure, isTrue);

        await cubit.retrySave();
        expect(cubit.state.hasPendingSaveFailure, isFalse);
        expect(repository.savedExercises, hasLength(3));
        await cubit.close();
      },
    );

    test(
      'corrupt saved data surfaces a failure with recovery to empty',
      () async {
        final FakeWorkoutRepository repository = FakeWorkoutRepository()
          ..loadFailure = const CorruptSavedWorkoutException();
        final WorkoutCubit cubit = WorkoutCubit(repository: repository);

        await cubit.loadWorkout();
        expect(cubit.state.status, WorkoutStatus.failure);
        expect(
          cubit.state.failureReason,
          WorkoutFailureReason.corruptSavedWorkout,
        );

        await cubit.startEmpty();
        expect(cubit.state.status, WorkoutStatus.empty);
        expect(cubit.state.progress.percent, 0);
        expect(repository.savedExercises, isEmpty);
        await cubit.close();
      },
    );
  });
}
