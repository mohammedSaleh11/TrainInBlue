import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Blocs/onboarding/onboarding_cubit.dart';
import '../../Core/constants/app_assets.dart';
import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../Core/services/navigation_service.dart';
import '../../components/buttons/primary_action_button.dart';
import '../../widgets/dot_page_indicator.dart';
import '../workout/workout_home_screen.dart';
import 'components/onboarding_page.dart';

class _OnboardingPageContent {
  const _OnboardingPageContent({
    required this.imageAsset,
    required this.headline,
    required this.copy,
  });

  final String imageAsset;
  final String headline;
  final String copy;
}

const List<_OnboardingPageContent> _pages = <_OnboardingPageContent>[
  _OnboardingPageContent(
    imageAsset: AppAssets.onboardingBuild,
    headline: AppStrings.onboardingBuildHeadline,
    copy: AppStrings.onboardingBuildCopy,
  ),
  _OnboardingPageContent(
    imageAsset: AppAssets.onboardingProgress,
    headline: AppStrings.onboardingProgressHeadline,
    copy: AppStrings.onboardingProgressCopy,
  ),
  _OnboardingPageContent(
    imageAsset: AppAssets.onboardingResume,
    headline: AppStrings.onboardingResumeHeadline,
    copy: AppStrings.onboardingResumeCopy,
  ),
];

/// Three-page introduction shown on first launch. Skipping or finishing
/// persists completion and replaces the stack, so Back never returns here.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finishOnboarding() async {
    await context.read<OnboardingCubit>().completeOnboarding();
    await NavigationService.pushAndRemove(const WorkoutHomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.iceBackground,
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) => _currentPage.value = page,
            itemBuilder: (BuildContext context, int index) {
              final _OnboardingPageContent page = _pages[index];
              return OnboardingPage(
                imageAsset: page.imageAsset,
                headline: page.headline,
                copy: page.copy,
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _currentPage,
            builder: (BuildContext context, int currentPage, Widget? _) {
              final bool isLastPage = currentPage == _pages.length - 1;
              return Stack(
                children: <Widget>[
                  if (!isLastPage)
                    SafeArea(
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: 12.h,
                            end: 16.w,
                          ),
                          child: _SkipChip(onPressed: _finishOnboarding),
                        ),
                      ),
                    ),
                  SafeArea(
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          24.w,
                          0,
                          24.w,
                          16.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            DotPageIndicator(
                              pageCount: _pages.length,
                              currentPage: currentPage,
                            ),
                            SizedBox(height: 18.h),
                            Row(
                              children: <Widget>[
                                if (currentPage > 0) ...<Widget>[
                                  OutlinedButton(
                                    key: AppKeys.onboardingBack,
                                    onPressed: () =>
                                        _goToPage(currentPage - 1),
                                    child: const Text(AppStrings.back),
                                  ),
                                  SizedBox(width: 12.w),
                                ],
                                Expanded(
                                  child: isLastPage
                                      ? PrimaryActionButton(
                                          key: AppKeys.onboardingFinish,
                                          label: AppStrings.buildMyWorkout,
                                          onPressed: _finishOnboarding,
                                        )
                                      : PrimaryActionButton(
                                          key: AppKeys.onboardingNext,
                                          label: AppStrings.next,
                                          onPressed: () =>
                                              _goToPage(currentPage + 1),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Frosted "Skip" pill that stays readable on top of the hero photo.
class _SkipChip extends StatelessWidget {
  const _SkipChip({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: AppKeys.onboardingSkip,
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppColorPalette.heroScrim,
        foregroundColor: AppColorPalette.textOnDark,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 18.w,
          vertical: 10.h,
        ),
        shape: const StadiumBorder(),
      ),
      child: const Text(AppStrings.skip),
    );
  }
}
