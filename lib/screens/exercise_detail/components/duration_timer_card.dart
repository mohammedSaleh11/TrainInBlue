import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../data/models/active_exercise_timer.dart';
import 'detail_panel.dart';
import 'duration_timer_body.dart';
import 'duration_timer_set_pill.dart';
import 'set_tracker_parts.dart';

/// Countdown for one set of a duration exercise, driven by [WorkoutCubit]
/// so the timer keeps running after leaving this screen.
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

class _DurationTimerCardState extends State<DurationTimerCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<WorkoutCubit>().ensureTimer(
        exerciseId: widget.exerciseId,
        totalSeconds: widget.durationSeconds,
      );
    });
  }

  bool get _allSetsDone =>
      widget.sets > 0 && widget.completedSets >= widget.sets;
  int get _currentSet => (widget.completedSets + 1).clamp(1, widget.sets);

  void _toggle() {
    if (_allSetsDone) {
      return;
    }
    context.read<WorkoutCubit>().toggleTimer(
      exerciseId: widget.exerciseId,
      totalSeconds: widget.durationSeconds,
    );
  }

  void _restart() {
    if (_allSetsDone) {
      return;
    }
    HapticFeedback.selectionClick();
    context.read<WorkoutCubit>().restartTimer(
      exerciseId: widget.exerciseId,
      totalSeconds: widget.durationSeconds,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          BlocSelector<WorkoutCubit, WorkoutState, ActiveExerciseTimer?>(
            selector: (WorkoutState state) =>
                state.timerFor(widget.exerciseId),
            builder: (BuildContext context, ActiveExerciseTimer? timer) {
              return DurationTimerBody(
                timer:
                    timer ??
                    ActiveExerciseTimer.fresh(
                      exerciseId: widget.exerciseId,
                      totalSeconds: widget.durationSeconds,
                    ),
                allSetsDone: _allSetsDone,
                onToggle: _toggle,
                onRestart: _restart,
              );
            },
          ),
        ],
      ),
    );
  }
}
