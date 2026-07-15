import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';

/// Start/pause + restart while a set is in progress.
class DurationTimerRunningActions extends StatelessWidget {
  const DurationTimerRunningActions({
    super.key,
    required this.isAnimating,
    required this.canRestart,
    required this.toggleLabel,
    required this.onToggle,
    required this.onRestart,
  });

  final bool isAnimating;
  final bool canRestart;
  final String toggleLabel;
  final VoidCallback onToggle;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton.icon(
            key: AppKeys.timerToggleButton,
            onPressed: onToggle,
            icon: Icon(
              isAnimating ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            label: Text(toggleLabel),
          ),
        ),
        SizedBox(width: 10.w),
        OutlinedButton.icon(
          key: AppKeys.timerRestartButton,
          onPressed: canRestart ? onRestart : null,
          icon: const Icon(Icons.replay_rounded),
          label: const Text(AppStrings.timerRestart),
        ),
      ],
    );
  }
}

/// After a set ends: advance to the next set, or restart this one.
class DurationTimerFinishedActions extends StatelessWidget {
  const DurationTimerFinishedActions({
    super.key,
    required this.hasMoreSets,
    required this.isLastSet,
    required this.onNextSet,
    required this.onRestart,
  });

  final bool hasMoreSets;
  final bool isLastSet;
  final VoidCallback onNextSet;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    if (!hasMoreSets) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          key: AppKeys.timerRestartButton,
          onPressed: onRestart,
          icon: const Icon(Icons.replay_rounded),
          label: const Text(AppStrings.timerRestart),
        ),
      );
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: FilledButton.icon(
            key: AppKeys.timerNextSetButton,
            onPressed: onNextSet,
            icon: Icon(
              isLastSet ? Icons.check_rounded : Icons.skip_next_rounded,
            ),
            label: Text(
              isLastSet
                  ? AppStrings.timerFinishLastSet
                  : AppStrings.timerNextSet,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        OutlinedButton.icon(
          key: AppKeys.timerRestartButton,
          onPressed: onRestart,
          icon: const Icon(Icons.replay_rounded),
          label: const Text(AppStrings.timerRestart),
        ),
      ],
    );
  }
}
