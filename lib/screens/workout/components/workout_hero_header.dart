import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/daypart.dart';
import '../../../Core/constants/app_assets.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../app_theme/theme_extension.dart';
import 'workout_exercise_count_badge.dart';

/// Hero header of the workout home: brand row with overflow menu on top of
/// the studio photograph, and the session title anchored to the bottom.
class WorkoutHeroHeader extends StatelessWidget {
  const WorkoutHeroHeader({
    super.key,
    required this.onResetWorkout,
    required this.exerciseCount,
  });

  final VoidCallback onResetWorkout;
  final int exerciseCount;

  String get _greeting => switch (Daypart.of(DateTime.now())) {
    Daypart.morning => AppStrings.goodMorning,
    Daypart.afternoon => AppStrings.goodAfternoon,
    Daypart.evening => AppStrings.goodEvening,
  };

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.viewPaddingOf(context).top;
    return SizedBox(
      height: 280.h + topInset,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(32.r),
          bottomEnd: Radius.circular(32.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              AppAssets.workoutHero,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              cacheWidth: (MediaQuery.sizeOf(context).width *
                      MediaQuery.devicePixelRatioOf(context))
                  .round(),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: <double>[0, 0.45, 1],
                  colors: <Color>[
                    Color(0x660A1E4A),
                    Color(0x140A1E4A),
                    Color(0xB30A1E4A),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                20.w,
                topInset + 10.h,
                12.w,
                18.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9.r),
                        child: Image.asset(
                          AppAssets.appIcon,
                          width: 30.w,
                          height: 30.w,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColorPalette.textOnDark,
                        ),
                      ),
                      const Spacer(),
                      _OverflowMenu(onResetWorkout: onResetWorkout),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '$_greeting · ${DateLabels.short(DateTime.now())}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: AppColorPalette.textOnDark.withValues(alpha: 0.88),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          AppStrings.yourWorkout,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColorPalette.textOnDark,
                          ),
                        ),
                      ),
                      if (exerciseCount > 0)
                        WorkoutExerciseCountBadge(count: exerciseCount),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppStrings.workoutSubtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColorPalette.textOnDark.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({required this.onResetWorkout});

  final VoidCallback onResetWorkout;

  @override
  Widget build(BuildContext context) {
    final CustomColors colors = Theme.of(context).extension<CustomColors>()!;
    return Container(
      decoration: const BoxDecoration(
        color: AppColorPalette.frostedOnImage,
        shape: BoxShape.circle,
      ),
      child: PopupMenuButton<String>(
        key: AppKeys.workoutMenuButton,
        tooltip: 'Workout options',
        icon: const Icon(Icons.more_horiz, color: AppColorPalette.textOnDark),
        onSelected: (_) => onResetWorkout(),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            key: AppKeys.resetWorkoutMenuItem,
            value: 'reset',
            child: Row(
              children: <Widget>[
                Icon(Icons.restart_alt, size: 20.r, color: colors.destructive),
                SizedBox(width: 10.w),
                Text(
                  AppStrings.resetWorkout,
                  style: TextStyle(color: colors.destructive),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
