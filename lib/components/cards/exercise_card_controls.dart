import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../data/models/exercise.dart';

/// Soft category chip — sky accent on dark media.
class ExerciseCategoryBadge extends StatelessWidget {
  const ExerciseCategoryBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorPalette.textOnDark.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 10.w,
          vertical: 5.h,
        ),
        child: Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColorPalette.textOnDark,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            height: 1.1,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}

/// Clear completion control — soft glass ring until checked.
class ExerciseCompletionRing extends StatelessWidget {
  const ExerciseCompletionRing({
    super.key,
    required this.exercise,
    required this.onPressed,
  });

  final Exercise exercise;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool done = exercise.isCompleted;

    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: done ? AppStrings.reopenExercise : AppStrings.markComplete,
        child: InkWell(
          key: AppKeys.completeToggle(exercise.id),
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 32.r,
            height: 32.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? AppColorPalette.textOnDark
                  : AppColorPalette.textOnDark.withValues(alpha: 0.14),
              border: Border.all(
                width: 1.4,
                color: AppColorPalette.textOnDark.withValues(
                  alpha: done ? 1 : 0.75,
                ),
              ),
            ),
            child: done
                ? Icon(
                    Icons.check_rounded,
                    size: 17.r,
                    color: AppColorPalette.deepNavy,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Readable set progress — brand fill, clear status copy.
class ExerciseSetProgress extends StatelessWidget {
  const ExerciseSetProgress({
    super.key,
    required this.completedSets,
    required this.totalSets,
  });

  final int completedSets;
  final int totalSets;

  @override
  Widget build(BuildContext context) {
    final bool allDone = completedSets >= totalSets && totalSets > 0;
    final double progress = totalSets == 0
        ? 0
        : (completedSets / totalSets).clamp(0, 1);

    return Row(
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 3.5.h,
              backgroundColor:
                  AppColorPalette.textOnDark.withValues(alpha: 0.22),
              color: allDone
                  ? AppColorPalette.textOnDark
                  : AppColorPalette.skyBlue,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          AppStrings.setsTrackedLabel(completedSets, totalSets),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColorPalette.textOnDark.withValues(alpha: 0.88),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
