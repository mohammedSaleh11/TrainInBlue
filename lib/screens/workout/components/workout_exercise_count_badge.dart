import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Compact exercise-count chip for the workout hero title row.
class WorkoutExerciseCountBadge extends StatelessWidget {
  const WorkoutExerciseCountBadge({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final String label = AppStrings.exerciseCountLabel(count);
    return Semantics(
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColorPalette.frostedOnImage,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: AppColorPalette.textOnDark.withValues(alpha: 0.28),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 11.w,
            vertical: 6.h,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
              color: AppColorPalette.textOnDark,
            ),
          ),
        ),
      ),
    );
  }
}
