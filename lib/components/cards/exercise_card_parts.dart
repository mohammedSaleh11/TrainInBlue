import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../app_theme/theme_extension.dart';
import '../../data/models/exercise.dart';
import '../../widgets/exercise_image.dart';

/// Minimal completion ring — tap to mark done or reopen.
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
    final CustomColors colors = Theme.of(context).extension<CustomColors>()!;
    final bool done = exercise.isCompleted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: AppKeys.completeToggle(exercise.id),
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32.r,
          height: 32.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? colors.successSurface : AppColorPalette.surfaceTintBlue,
            border: Border.all(
              width: 1.5,
              color: done ? colors.success : AppColorPalette.outlineSoft,
            ),
          ),
          child: done
              ? Icon(Icons.check_rounded, size: 18.r, color: colors.success)
              : Icon(
                  Icons.circle_outlined,
                  size: 18.r,
                  color: AppColorPalette.textMuted,
                ),
        ),
      ),
    );
  }
}

/// Rounded exercise photo with a soft shadow.
class ExerciseCardPhoto extends StatelessWidget {
  const ExerciseCardPhoto({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final bool done = exercise.isCompleted;

    return Hero(
      tag: 'exercise-image-${exercise.id}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColorPalette.deepNavy.withValues(alpha: 0.1),
              blurRadius: 18.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: SizedBox(
            width: 102.w,
            height: 102.w,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                ExerciseImage(
                  name: exercise.name,
                  category: exercise.category,
                  expand: true,
                ),
                if (done)
                  ColoredBox(
                    color: AppColorPalette.surfaceWhite.withValues(alpha: 0.38),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Category pill under the title block.
class ExerciseCategoryTag extends StatelessWidget {
  const ExerciseCategoryTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceTintBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColorPalette.primaryBlueDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// One readable stat row — icon plus full label, wraps naturally.
class ExerciseStatLine extends StatelessWidget {
  const ExerciseStatLine({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsetsDirectional.only(top: 1.h),
          child: Icon(icon, size: 16.r, color: AppColorPalette.primaryBlue),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColorPalette.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Set progress for repetition exercises on list cards.
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool allDone = completedSets >= totalSets;
    final double progress = totalSets == 0
        ? 0
        : (completedSets / totalSets).clamp(0, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.h),
        Text(
          AppStrings.setsTrackedLabel(completedSets, totalSets),
          style: textTheme.labelMedium?.copyWith(
            color: allDone
                ? AppColorPalette.successGreen
                : AppColorPalette.primaryBlueDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5.h,
            backgroundColor: AppColorPalette.surfaceTintBlue,
            color: allDone
                ? AppColorPalette.successGreen
                : AppColorPalette.primaryBlue,
          ),
        ),
      ],
    );
  }
}
