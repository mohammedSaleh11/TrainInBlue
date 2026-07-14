import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Blocs/workout/workout_cubit.dart';
import 'package:train_in_blue/Core/constants/app_keys.dart';
import 'package:train_in_blue/Core/constants/app_strings.dart';
import 'package:train_in_blue/data/models/exercise.dart';
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

  testWidgets('completing an exercise updates progress and persists', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(id: 'ex-1', order: 0, name: 'Squat', isCompleted: true),
        buildExercise(id: 'ex-2', order: 1, name: 'Push-up'),
        buildExercise(id: 'ex-3', order: 2, name: 'Plank'),
      ],
    );

    expect(find.text('1 of 3 complete'), findsOneWidget);
    expect(find.text('2 remaining'), findsOneWidget);
    expect(find.byKey(AppKeys.completeToggle('ex-1')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(AppKeys.exerciseCard('ex-2')),
      120,
      scrollable: find.descendant(
        of: find.byKey(AppKeys.exerciseList),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.ensureVisible(find.byKey(AppKeys.completeToggle('ex-2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.completeToggle('ex-2')));
    await tester.pumpAndSettle();

    expect(workoutCubit.state.progress.completedCount, 2);
    expect(workoutCubit.state.progress.remainingCount, 1);
    expect(
      repository.savedExercises!.firstWhere(
        (Exercise exercise) => exercise.id == 'ex-2',
      ).isCompleted,
      isTrue,
    );
  });

  testWidgets('reopening a completed exercise updates progress back', (
    WidgetTester tester,
  ) async {
    await pumpHome(
      tester,
      savedExercises: <Exercise>[
        buildExercise(id: 'ex-1', order: 0, isCompleted: true),
        buildExercise(id: 'ex-2', order: 1),
      ],
    );

    await tester.tap(find.byKey(AppKeys.completeToggle('ex-1')));
    await tester.pumpAndSettle();

    expect(find.text('0 of 2 complete'), findsOneWidget);
    expect(repository.savedExercises!.first.isCompleted, isFalse);
  });

  testWidgets('empty workout shows safe 0% progress and add action', (
    WidgetTester tester,
  ) async {
    await pumpHome(tester, savedExercises: const <Exercise>[]);

    expect(find.text('0%'), findsOneWidget);
    expect(find.text('0 of 0 complete'), findsOneWidget);
    expect(find.text(AppStrings.emptyTitle), findsOneWidget);
    expect(find.text(AppStrings.addExercise), findsOneWidget);
  });
}
