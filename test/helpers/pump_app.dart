import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:train_in_blue/Blocs/onboarding/onboarding_cubit.dart';
import 'package:train_in_blue/Blocs/workout/workout_cubit.dart';
import 'package:train_in_blue/Core/services/navigation_service.dart';
import 'package:train_in_blue/app_theme/app_theme.dart';

/// Pumps [home] inside the real app shell (theme, screen adaptation, and the
/// global navigator key) with the provided cubits.
Future<void> pumpApp(
  WidgetTester tester, {
  required Widget home,
  WorkoutCubit? workoutCubit,
  OnboardingCubit? onboardingCubit,
}) async {
  // Phone-sized surface (390x844 logical) matching the design canvas, so
  // layouts and hit targets behave like on a real device.
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  Widget shell = ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    builder: (_, _) => MaterialApp(
      theme: AppTheme.light,
      navigatorKey: NavigationService.navigatorKey,
      home: home,
    ),
  );
  if (workoutCubit != null) {
    shell = BlocProvider<WorkoutCubit>.value(value: workoutCubit, child: shell);
  }
  if (onboardingCubit != null) {
    shell = BlocProvider<OnboardingCubit>.value(
      value: onboardingCubit,
      child: shell,
    );
  }
  await tester.pumpWidget(shell);
}
