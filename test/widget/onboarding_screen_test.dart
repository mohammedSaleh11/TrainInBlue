import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Blocs/onboarding/onboarding_cubit.dart';
import 'package:train_in_blue/Blocs/workout/workout_cubit.dart';
import 'package:train_in_blue/Core/constants/app_keys.dart';
import 'package:train_in_blue/Core/constants/app_strings.dart';
import 'package:train_in_blue/screens/onboarding/onboarding_screen.dart';
import 'package:train_in_blue/screens/workout/workout_home_screen.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/pump_app.dart';

void main() {
  late FakeOnboardingRepository onboardingRepository;
  late OnboardingCubit onboardingCubit;
  late WorkoutCubit workoutCubit;

  Future<void> pumpOnboarding(WidgetTester tester) async {
    onboardingRepository = FakeOnboardingRepository();
    onboardingCubit = OnboardingCubit(repository: onboardingRepository);
    workoutCubit = WorkoutCubit(repository: FakeWorkoutRepository());
    addTearDown(onboardingCubit.close);
    addTearDown(workoutCubit.close);
    // Preloaded so the home screen is ready as soon as onboarding finishes.
    await workoutCubit.loadWorkout();
    await pumpApp(
      tester,
      home: const OnboardingScreen(),
      onboardingCubit: onboardingCubit,
      workoutCubit: workoutCubit,
    );
  }

  testWidgets('Next and Back navigate through all three pages', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);
    expect(find.text(AppStrings.onboardingBuildHeadline), findsOneWidget);
    expect(find.byKey(AppKeys.onboardingBack), findsNothing);

    await tester.tap(find.byKey(AppKeys.onboardingNext));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingProgressHeadline), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.onboardingBack));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingBuildHeadline), findsOneWidget);

    await tester.tap(find.byKey(AppKeys.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.onboardingNext));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingResumeHeadline), findsOneWidget);
    expect(find.byKey(AppKeys.onboardingFinish), findsOneWidget);
    expect(find.byKey(AppKeys.onboardingSkip), findsNothing);
  });

  testWidgets('Skip stores completion and opens the workout', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);

    await tester.tap(find.byKey(AppKeys.onboardingSkip));
    await tester.pumpAndSettle();

    expect(onboardingRepository.isCompleted(), isTrue);
    expect(find.byType(WorkoutHomeScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('final call to action stores completion and opens the workout', (
    WidgetTester tester,
  ) async {
    await pumpOnboarding(tester);

    await tester.tap(find.byKey(AppKeys.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.onboardingNext));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AppKeys.onboardingFinish));
    await tester.pumpAndSettle();

    expect(onboardingRepository.isCompleted(), isTrue);
    expect(find.byType(WorkoutHomeScreen), findsOneWidget);
  });
}
