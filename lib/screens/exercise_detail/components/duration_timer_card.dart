import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import 'detail_panel.dart';
import 'duration_timer_actions.dart';
import 'duration_timer_ring.dart';
import 'duration_timer_set_pill.dart';
import 'set_tracker_parts.dart';

/// Countdown for one set of a duration exercise, with next-set progression.
///
/// Animation ticks rebuild only the ring and action row via [AnimatedBuilder];
/// set progress chrome stays in the [child] slot and is not repainted per frame.
class DurationTimerCard extends StatefulWidget {
  const DurationTimerCard({
    super.key,
    required this.exerciseId,
    required this.durationSeconds,
    required this.sets,
    required this.completedSets,
  });

  final String exerciseId;
  final int durationSeconds;
  final int sets;
  final int completedSets;

  @override
  State<DurationTimerCard> createState() => _DurationTimerCardState();
}

class _DurationTimerCardState extends State<DurationTimerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _allSetsDone =>
      widget.sets > 0 && widget.completedSets >= widget.sets;
  int get _currentSet => (widget.completedSets + 1).clamp(1, widget.sets);
  bool get _isLastSet => widget.completedSets >= widget.sets - 1;

  void _toggle() {
    _controller.isAnimating ? _controller.stop() : _controller.forward();
  }

  void _restart() {
    HapticFeedback.selectionClick();
    _controller
      ..reset()
      ..forward();
  }

  void _advanceSet() {
    if (_allSetsDone) {
      return;
    }
    HapticFeedback.mediumImpact();
    context.read<WorkoutCubit>().trackCompletedSets(
      widget.exerciseId,
      widget.completedSets + 1,
    );
    _controller.reset();
  }

  String _clock(double progress) {
    final int remaining = (widget.durationSeconds * (1 - progress)).ceil();
    final int minutes = remaining ~/ 60;
    final int seconds = remaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DetailPanel(
      title: AppStrings.setTimerTitle,
      icon: Icons.timer_outlined,
      trailing: DurationTimerSetPill(
        label: _allSetsDone
            ? AppStrings.setsTrackedLabel(widget.completedSets, widget.sets)
            : AppStrings.timerSetLabel(_currentSet, widget.sets),
        done: _allSetsDone,
      ),
      child: Column(
        children: <Widget>[
          if (widget.sets > 1) ...<Widget>[
            SegmentedSetProgress(
              total: widget.sets,
              done: widget.completedSets,
            ),
            SizedBox(height: 18.h),
          ],
          AnimatedBuilder(
            animation: _controller,
            child: const SizedBox.shrink(),
            builder: (BuildContext context, Widget? _) {
              final bool finished = _controller.isCompleted;
              final String toggleLabel = _controller.isAnimating
                  ? AppStrings.timerPause
                  : _controller.value > 0
                  ? AppStrings.timerResume
                  : AppStrings.timerStart;
              return Column(
                children: <Widget>[
                  DurationTimerRing(
                    consumed: _controller.value,
                    finished: finished,
                    clock: _clock(_controller.value),
                  ),
                  SizedBox(height: 16.h),
                  if (finished || _allSetsDone) ...<Widget>[
                    Text(
                      _allSetsDone
                          ? AppStrings.allSetsTracked
                          : AppStrings.timerDone,
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColorPalette.successInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 14.h),
                  ],
                  if (finished)
                    DurationTimerFinishedActions(
                      hasMoreSets: !_allSetsDone,
                      isLastSet: _isLastSet,
                      onNextSet: _advanceSet,
                      onRestart: _restart,
                    )
                  else
                    DurationTimerRunningActions(
                      isAnimating: _controller.isAnimating,
                      canRestart: _controller.value > 0,
                      toggleLabel: toggleLabel,
                      onToggle: _toggle,
                      onRestart: _restart,
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
