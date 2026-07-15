import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Blocs/onboarding/onboarding_cubit.dart';
import '../../Core/constants/app_assets.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../Core/services/navigation_service.dart';
import '../onboarding/onboarding_screen.dart';
import '../workout/workout_home_screen.dart';
import 'components/splash_background.dart';
import 'components/splash_brand.dart';

/// Animated brand splash. While the intro plays, the app has already started
/// loading the onboarding flag and saved workout, so the next screen appears
/// fully ready and saved data never flashes.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Duration _minimumDisplayTime = Duration(milliseconds: 2600);

  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _wordmarkFade;
  late final Animation<Offset> _wordmarkSlide;
  late final Animation<double> _taglineFade;

  Timer? _minimumDisplayTimer;
  bool _minimumTimeElapsed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat(reverse: true);

    _logoScale = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, 0.5, curve: Curves.easeOutBack),
    ).drive(Tween<double>(begin: 0.55, end: 1));
    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, 0.35, curve: Curves.easeOut),
    );
    _wordmarkFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );
    _wordmarkSlide = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.4, 0.75, curve: Curves.easeOutCubic),
    ).drive(Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero));
    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.65, 1, curve: Curves.easeOut),
    );

    _minimumDisplayTimer = Timer(_minimumDisplayTime, () {
      _minimumTimeElapsed = true;
      _openNextScreen();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_precacheBrandAssets());
    });
  }

  /// Warm the image cache during the splash so the next screen paints hot.
  Future<void> _precacheBrandAssets() async {
    if (!mounted) {
      return;
    }
    final List<String> assets = <String>[
      AppAssets.appIcon,
      AppAssets.workoutHero,
      AppAssets.onboardingBuild,
      AppAssets.onboardingProgress,
      AppAssets.onboardingResume,
      AppAssets.emptyWorkout,
      AppAssets.celebration,
    ];
    await Future.wait(
      assets.map(
        (String path) => precacheImage(AssetImage(path), context),
      ),
    );
  }

  @override
  void dispose() {
    _minimumDisplayTimer?.cancel();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Navigates once the intro has played and the onboarding flag is known.
  void _openNextScreen() {
    if (_hasNavigated || !_minimumTimeElapsed || !mounted) {
      return;
    }
    final OnboardingStatus status = context.read<OnboardingCubit>().state;
    if (status == OnboardingStatus.unknown) {
      return;
    }
    _hasNavigated = true;
    NavigationService.pushReplacement(
      status == OnboardingStatus.completed
          ? const WorkoutHomeScreen()
          : const OnboardingScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingStatus>(
      listener: (_, _) => _openNextScreen(),
      child: Scaffold(
        body: SplashBackground(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: PulsingLogo(pulse: _pulseController),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  FadeTransition(
                    opacity: _wordmarkFade,
                    child: SlideTransition(
                      position: _wordmarkSlide,
                      child: const BrandWordmark(),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      AppStrings.splashTagline,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.4,
                        color: AppColorPalette.textOnDark.withValues(
                          alpha: 0.75,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
