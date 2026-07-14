import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Title row above the exercise list inside a soft surface bar with icon and
/// a gradient count badge.
class WorkoutSectionHeader extends StatelessWidget {
  const WorkoutSectionHeader({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceWhite,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColorPalette.outlineSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36.r,
            height: 36.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColorPalette.surfaceTintBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              size: 18.r,
              color: AppColorPalette.primaryBlue,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              AppStrings.exercisesSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[
                  AppColorPalette.primaryBlue,
                  AppColorPalette.primaryBlueDark,
                ],
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColorPalette.textOnDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
