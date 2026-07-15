import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../data/models/active_exercise_timer.dart';

/// Modern live timer strip for duration exercises on the home card.
class ExerciseCardLiveTimer extends StatelessWidget {
  const ExerciseCardLiveTimer({
    super.key,
    required this.completedSets,
    required this.totalSets,
    this.activeTimer,
  });

  final int completedSets;
  final int totalSets;
  final ActiveExerciseTimer? activeTimer;

  bool get _allDone => totalSets > 0 && completedSets >= totalSets;
  int get _currentSet => (completedSets + 1).clamp(1, totalSets);

  bool get _timerActive {
    final ActiveExerciseTimer? timer = activeTimer;
    return timer != null &&
        (timer.isRunning || timer.hasStarted || timer.isFinished);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ActiveExerciseTimer? timer = activeTimer;
    final bool live = _timerActive && timer != null && !_allDone;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorPalette.textOnDark.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.18),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.w, 10.h, 12.w, 10.h),
        child: Row(
          children: <Widget>[
            if (live) ...<Widget>[
              _MiniRing(progress: timer.consumed, running: timer.isRunning),
              SizedBox(width: 10.w),
              Text(
                timer.clockLabel,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColorPalette.textOnDark,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                width: 1,
                height: 18.h,
                color: AppColorPalette.textOnDark.withValues(alpha: 0.22),
              ),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _allDone
                        ? AppStrings.setsTrackedLabel(completedSets, totalSets)
                        : AppStrings.timerSetLabel(_currentSet, totalSets),
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColorPalette.textOnDark.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _SetDots(total: totalSets, done: completedSets),
                ],
              ),
            ),
            if (live && timer.isRunning)
              Icon(
                Icons.graphic_eq_rounded,
                size: 16.r,
                color: AppColorPalette.skyBlue,
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniRing extends StatelessWidget {
  const _MiniRing({required this.progress, required this.running});

  final double progress;
  final bool running;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.r,
      height: 28.r,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            value: 1,
            strokeWidth: 2.5,
            color: AppColorPalette.textOnDark.withValues(alpha: 0.18),
          ),
          CircularProgressIndicator(
            value: progress.clamp(0, 1),
            strokeWidth: 2.5,
            color: running
                ? AppColorPalette.skyBlue
                : AppColorPalette.textOnDark,
            strokeCap: StrokeCap.round,
          ),
          Icon(
            running ? Icons.play_arrow_rounded : Icons.pause_rounded,
            size: 12.r,
            color: AppColorPalette.textOnDark,
          ),
        ],
      ),
    );
  }
}

class _SetDots extends StatelessWidget {
  const _SetDots({required this.total, required this.done});

  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    final int count = total.clamp(0, 8);
    return Row(
      children: List<Widget>.generate(count, (int index) {
        final bool filled = index < done;
        final bool current = index == done && done < total;
        return Padding(
          padding: EdgeInsetsDirectional.only(end: index == count - 1 ? 0 : 5.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: current ? 14.w : 7.w,
            height: 7.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: filled || current
                  ? (filled
                        ? AppColorPalette.textOnDark
                        : AppColorPalette.skyBlue)
                  : AppColorPalette.textOnDark.withValues(alpha: 0.28),
            ),
          ),
        );
      }),
    );
  }
}
