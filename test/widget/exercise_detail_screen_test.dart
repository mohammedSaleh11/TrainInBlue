import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Blocs/workout/workout_cubit.dart';
import 'package:train_in_blue/Core/constants/app_keys.dart';
import 'package:train_in_blue/Core/constants/app_strings.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/models/exercise_target_type.dart';
import 'package:train_in_blue/screens/workout/workout_home_screen.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  late FakeWorkoutRepository repository;
  late WorkoutCubit workoutCubit;

  Future<void> pumpHome(
    WidgetTester tester, {
    required List<Exercise> savedExercises,
  }) async {
    repository = FakeWorkoutRepository(savedExercises: savedExercises);
    workoutCubit = WorkoutCubit(repository: repository);
    addTearDown(workoutCubit.close);
    await workoutCubit.loadWorkout();
    await pumpApp(
      tester,
      home: const WorkoutHomeScreen(),
      workoutCubit: workoutCubit,
    );
    await tester.pumpAndSettle();
  }

  Future<void> openDetail(WidgetTester tester, String exerciseId) async {
    await tester.tap(find.byKey(AppKeys.exerciseCard(exerciseId)));
    await tester.pumpAndSettle();
  }

  testWidgets('tapping a card opens detail; completing there persists '
      'and home progress updates', (WidgetTester tester) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(id: 'ex-1', order: 0, name: 'Squat'),
        buildExercise(id: 'ex-2', order: 1, name: 'Push-up'),
      ],
    );

    await openDetail(tester, 'ex-1');

    expect(find.text('Squat'), findsWidgets);
    expect(find.text(AppStrings.setTrackerTitle), findsOneWidget);
    expect(find.text(AppStrings.markComplete), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.detailCompleteButton));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.reopenExercise), findsOneWidget);
    final Exercise persisted = repository.savedExercises!.firstWhere(
      (Exercise exercise) => exercise.id == 'ex-1',
    );
    expect(persisted.isCompleted, isTrue);

    await tester.tap(find.byKey(AppKeys.detailBackButton));
    await tester.pumpAndSettle();

    expect(find.text('1 of 2 complete'), findsOneWidget);
  });

  testWidgets('set tracker counts tapped sets', (WidgetTester tester) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(id: 'ex-1', order: 0, name: 'Squat', sets: 3),
      ],
    );

    await openDetail(tester, 'ex-1');
    expect(find.text(AppStrings.setTrackerTitle), findsOneWidget);
    expect(find.text(AppStrings.markComplete), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.setDot(0)));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.setsTrackedLabel(1, 3)), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.setDot(2)));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.setsTrackedLabel(3, 3)), findsOneWidget);
    expect(find.text(AppStrings.allSetsTracked), findsOneWidget);

    expect(repository.savedExercises!.first.completedSets, 3);

    await tester.tap(find.byKey(AppKeys.detailBackButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.setsTrackedLabel(3, 3)), findsOneWidget);
  });

  testWidgets('duration exercise gets a working countdown timer', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(
          id: 'ex-1',
          order: 0,
          name: 'Plank',
          category: 'Core',
          targetType: ExerciseTargetType.duration,
          durationSeconds: 30,
          sets: 1,
        ),
      ],
    );

    await openDetail(tester, 'ex-1');
    await tester.ensureVisible(find.byKey(AppKeys.timerToggleButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.setTimerTitle), findsOneWidget);
    expect(find.text('0:30'), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerToggleButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 15));
    expect(find.text('0:15'), findsOneWidget);

    await tester.pump(const Duration(seconds: 16));
    expect(find.text('0:00'), findsOneWidget);
    expect(find.text(AppStrings.timerDone), findsOneWidget);
    expect(find.byKey(AppKeys.timerNextSetButton), findsOneWidget);
    expect(find.text(AppStrings.timerFinishLastSet), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerNextSetButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.allSetsTracked), findsOneWidget);
    expect(repository.savedExercises!.first.completedSets, 1);
  });

  testWidgets('duration timer advances to the next set', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(
          id: 'ex-1',
          order: 0,
          name: 'Jumping Jacks',
          category: 'Cardio',
          targetType: ExerciseTargetType.duration,
          durationSeconds: 10,
          sets: 2,
        ),
      ],
    );

    await openDetail(tester, 'ex-1');
    await tester.ensureVisible(find.byKey(AppKeys.timerToggleButton));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.timerSetLabel(1, 2)), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerToggleButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 11));
    expect(find.text(AppStrings.timerDone), findsOneWidget);
    expect(find.text(AppStrings.timerNextSet), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerNextSetButton));
    await tester.pumpAndSettle();
    expect(repository.savedExercises!.first.completedSets, 1);
    expect(find.text(AppStrings.timerSetLabel(2, 2)), findsOneWidget);
    expect(find.text('0:10'), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerToggleButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 11));
    expect(find.text(AppStrings.timerFinishLastSet), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.timerNextSetButton));
    await tester.pumpAndSettle();
    expect(repository.savedExercises!.first.completedSets, 2);
    expect(find.text(AppStrings.allSetsTracked), findsOneWidget);
  });

  testWidgets('deleting from detail returns home and removes the exercise', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(id: 'ex-1', order: 0, name: 'Squat'),
        buildExercise(id: 'ex-2', order: 1, name: 'Push-up'),
      ],
    );

    await openDetail(tester, 'ex-1');
    await tester.tap(find.byKey(AppKeys.detailMenuButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.detailDeleteMenuItem));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.confirmDialogConfirm));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.progressTitle), findsOneWidget);
    expect(find.byKey(AppKeys.exerciseCard('ex-1')), findsNothing);
    expect(repository.savedExercises!.length, 1);
  });
}
