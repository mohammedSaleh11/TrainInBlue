import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Blocs/onboarding/onboarding_cubit.dart';
import 'Blocs/theme/theme_cubit.dart';
import 'Blocs/workout/workout_cubit.dart';
import 'Core/constants/app_strings.dart';
import 'Core/services/local_storage_service.dart';
import 'Core/services/navigation_service.dart';
import 'data/repositories/onboarding_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(TrainInBlueApp(storage: LocalStorageService(preferences)));
}

class TrainInBlueApp extends StatelessWidget {
  const TrainInBlueApp({super.key, required this.storage});

  final LocalStorageService storage;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<WorkoutRepository>(
          create: (_) => LocalWorkoutRepository(storage: storage),
        ),
        RepositoryProvider<OnboardingRepository>(
          create: (_) => LocalOnboardingRepository(storage: storage),
        ),
      ],
      child: MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<OnboardingCubit>(
            create: (BuildContext context) => OnboardingCubit(
              repository: RepositoryProvider.of<OnboardingRepository>(context),
            )..checkCompletion(),
          ),
          // Loading starts at launch so the splash screen can preload the
          // saved workout and the home screen never flashes stale data.
          BlocProvider<WorkoutCubit>(
            create: (BuildContext context) => WorkoutCubit(
              repository: RepositoryProvider.of<WorkoutRepository>(context),
            )..loadWorkout(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          builder: (_, _) => BlocBuilder<ThemeCubit, ThemeData>(
            builder: (BuildContext context, ThemeData theme) {
              return MaterialApp(
                title: AppStrings.appName,
                debugShowCheckedModeBanner: false,
                theme: theme,
                navigatorKey: NavigationService.navigatorKey,
                home: const SplashScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
