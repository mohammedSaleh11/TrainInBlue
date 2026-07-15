import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Category pill shown on the hero image.
class DetailHeroCategoryChip extends StatelessWidget {
  const DetailHeroCategoryChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorPalette.frostedOnImage,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColorPalette.textOnDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Completed badge on the hero image.
class DetailHeroCompletedChip extends StatelessWidget {
  const DetailHeroCompletedChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColorPalette.successGreen,
        borderRadius: BorderRadius.circular(999),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.successGreen.withValues(alpha: 0.4),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_rounded,
            size: 14.r,
            color: AppColorPalette.textOnDark,
          ),
          SizedBox(width: 4.w),
          Text(
            AppStrings.completedLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColorPalette.textOnDark,
            ),
          ),
        ],
      ),
    );
  }
}
