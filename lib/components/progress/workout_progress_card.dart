import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../data/models/workout_progress.dart';
import 'progress_card_parts.dart';
import 'progress_ring.dart';

/// Live session summary on a cobalt gradient: percentage ring, completed and
/// remaining counts, and a motivation line that follows the session phase.
class WorkoutProgressCard extends StatelessWidget {
  const WorkoutProgressCard({super.key, required this.progress});

  final WorkoutProgress progress;

  String get _motivation => switch (progress.phase) {
    WorkoutPhase.notStarted => AppStrings.motivationNotStarted,
    WorkoutPhase.inProgress => AppStrings.motivationInProgress,
    WorkoutPhase.almostDone => AppStrings.motivationAlmostDone,
    WorkoutPhase.complete => AppStrings.motivationComplete,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      key: AppKeys.progressCard,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColorPalette.primaryBlue,
            AppColorPalette.primaryBlueDark,
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: <Widget>[
            PositionedDirectional(
              top: -30.h,
              end: -20.w,
              child: const ProgressGlowCircle(diameter: 120),
            ),
            PositionedDirectional(
              bottom: -40.h,
              start: -30.w,
              child: const ProgressGlowCircle(diameter: 140),
            ),
            Padding(
              padding: EdgeInsetsDirectional.all(18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[_summary(context), _ring(context)]),
                  SizedBox(height: 14.h),
                  _motivationRow(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summary(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.progressTitle,
            style: textTheme.titleMedium?.copyWith(
              color: AppColorPalette.textOnDark,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '${progress.completedCount} of ${progress.totalCount} complete',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColorPalette.textOnDark.withValues(alpha: 0.85),
            ),
          ),
          SizedBox(height: 10.h),
          if (progress.isComplete)
            const ProgressAllDonePill()
          else
            ProgressFrostedPill(label: '${progress.remainingCount} remaining'),
        ],
      ),
    );
  }

  Widget _ring(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 14.w),
      child: ProgressRing(
        fraction: progress.fraction,
        size: 82.w,
        strokeWidth: 9.r,
        trackColor: AppColorPalette.frostedOnImage,
        progressColor: AppColorPalette.textOnDark,
        center: Text(
          '${progress.percent}%',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColorPalette.textOnDark),
        ),
      ),
    );
  }

  Widget _motivationRow(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColorPalette.frostedOnImage,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.bolt_rounded, size: 18.r, color: AppColorPalette.skyBlue),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              _motivation,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColorPalette.textOnDark.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
