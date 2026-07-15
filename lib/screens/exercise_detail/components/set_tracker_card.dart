import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import 'detail_panel.dart';
import 'set_tracker_parts.dart';

/// Tap-to-fill set counter for repetition exercises.
class SetTrackerCard extends StatelessWidget {
  const SetTrackerCard({
    super.key,
    required this.exerciseId,
    required this.sets,
    required this.completedSets,
  });

  final String exerciseId;
  final int sets;
  final int completedSets;

  void _onDotTap(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    final int nextDone = index < completedSets ? index : index + 1;
    context.read<WorkoutCubit>().trackCompletedSets(exerciseId, nextDone);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool allDone = sets > 0 && completedSets >= sets;

    return DetailPanel(
      title: AppStrings.setTrackerTitle,
      icon: Icons.checklist_rounded,
      trailing: _StatusPill(done: completedSets, total: sets),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SegmentedSetProgress(total: sets, done: completedSets),
          SizedBox(height: 22.h),
          Center(
            child: Wrap(
              spacing: 14.w,
              runSpacing: 14.h,
              alignment: WrapAlignment.center,
              children: <Widget>[
                for (int i = 0; i < sets; i++)
                  SetDot(
                    key: AppKeys.setDot(i),
                    number: i + 1,
                    isDone: i < completedSets,
                    isCurrent: i == completedSets && !allDone,
                    onTap: () => _onDotTap(context, i),
                  ),
              ],
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: <Widget>[
              Icon(
                allDone ? Icons.celebration_rounded : Icons.touch_app_outlined,
                size: 16.r,
                color: allDone
                    ? AppColorPalette.successGreen
                    : AppColorPalette.textMuted,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  allDone
                      ? AppStrings.allSetsTracked
                      : AppStrings.setTrackerHint,
                  style: textTheme.bodySmall?.copyWith(
                    color: allDone
                        ? AppColorPalette.successGreen
                        : AppColorPalette.textMuted,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final bool allDone = total > 0 && done >= total;
    final bool started = done > 0;
    final Color surface = allDone
        ? AppColorPalette.successSurface
        : started
        ? AppColorPalette.surfaceTintBlue
        : AppColorPalette.iceBackground;
    final Color ink = allDone
        ? AppColorPalette.successInk
        : started
        ? AppColorPalette.primaryBlueDark
        : AppColorPalette.textSecondary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        AppStrings.setsTrackedLabel(done, total),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
