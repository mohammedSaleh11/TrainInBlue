import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/active_exercise_timer.dart';
import 'duration_timer_actions.dart';
import 'duration_timer_ring.dart';

/// Ring + action row for the duration set timer.
///
/// Finished sets are persisted automatically when the countdown hits zero, so
/// this body only needs start/pause/restart controls.
class DurationTimerBody extends StatelessWidget {
  const DurationTimerBody({
    super.key,
    required this.timer,
    required this.allSetsDone,
    required this.onToggle,
    required this.onRestart,
  });

  final ActiveExerciseTimer timer;
  final bool allSetsDone;
  final VoidCallback onToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool finished = timer.isFinished;
    final String toggleLabel = timer.isRunning
        ? AppStrings.timerPause
        : timer.hasStarted
        ? AppStrings.timerResume
        : AppStrings.timerStart;

    return Column(
      children: <Widget>[
        DurationTimerRing(
          consumed: timer.consumed,
          finished: finished || allSetsDone,
          clock: timer.clockLabel,
        ),
        SizedBox(height: 16.h),
        if (allSetsDone) ...<Widget>[
          Text(
            AppStrings.allSetsTracked,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              color: AppColorPalette.successInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ] else if (finished) ...<Widget>[
          Text(
            AppStrings.timerDone,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
              color: AppColorPalette.successInk,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 14.h),
          DurationTimerRunningActions(
            isAnimating: false,
            canRestart: true,
            toggleLabel: AppStrings.timerStart,
            onToggle: onRestart,
            onRestart: onRestart,
          ),
        ] else
          DurationTimerRunningActions(
            isAnimating: timer.isRunning,
            canRestart: timer.hasStarted,
            toggleLabel: toggleLabel,
            onToggle: onToggle,
            onRestart: onRestart,
          ),
      ],
    );
  }
}
