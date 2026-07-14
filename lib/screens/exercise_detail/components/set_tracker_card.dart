import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import 'detail_panel.dart';

/// Tap-to-fill set counter for repetition exercises with a linear progress bar.
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
    final int nextDone = index < completedSets ? index : index + 1;
    context.read<WorkoutCubit>().trackCompletedSets(exerciseId, nextDone);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool allDone = completedSets >= sets;
    final double progress = sets == 0 ? 0 : (completedSets / sets).clamp(0, 1);

    return DetailPanel(
      title: AppStrings.setTrackerTitle,
      icon: Icons.checklist_rounded,
      trailing: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 4.h,
        ),
        decoration: BoxDecoration(
          color: AppColorPalette.surfaceTintBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          AppStrings.setsTrackedLabel(completedSets, sets),
          style: textTheme.labelMedium?.copyWith(
            color: AppColorPalette.primaryBlueDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: AppColorPalette.surfaceTintBlue,
              color: allDone
                  ? AppColorPalette.successGreen
                  : AppColorPalette.primaryBlue,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: <Widget>[
              for (int i = 0; i < sets; i++)
                _SetDot(
                  key: AppKeys.setDot(i),
                  number: i + 1,
                  isDone: i < completedSets,
                  onTap: () => _onDotTap(context, i),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: <Widget>[
              Icon(
                allDone ? Icons.celebration_rounded : Icons.touch_app_outlined,
                size: 16.r,
                color: allDone
                    ? AppColorPalette.successGreen
                    : AppColorPalette.textMuted,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  allDone
                      ? AppStrings.allSetsTracked
                      : AppStrings.setTrackerHint,
                  style: textTheme.labelMedium?.copyWith(
                    color: allDone
                        ? AppColorPalette.successGreen
                        : AppColorPalette.textMuted,
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

class _SetDot extends StatelessWidget {
  const _SetDot({
    super.key,
    required this.number,
    required this.isDone,
    required this.onTap,
  });

  final int number;
  final bool isDone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: 48.r,
        height: 48.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isDone
              ? const LinearGradient(
                  colors: <Color>[
                    AppColorPalette.primaryBlue,
                    AppColorPalette.primaryBlueDark,
                  ],
                )
              : null,
          color: isDone ? null : AppColorPalette.surfaceTintBlue,
          border: Border.all(
            color: isDone
                ? AppColorPalette.primaryBlueDark
                : AppColorPalette.outlineSoft,
            width: isDone ? 0 : 1,
          ),
          boxShadow: isDone
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColorPalette.primaryBlue.withValues(alpha: 0.35),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.h),
                  ),
                ]
              : null,
        ),
        child: isDone
            ? Icon(
                Icons.check_rounded,
                size: 22.r,
                color: AppColorPalette.textOnDark,
              )
            : Text(
                '$number',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColorPalette.primaryBlueDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
