import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';

/// Soft decorative circle behind the gradient progress card content.
class ProgressGlowCircle extends StatelessWidget {
  const ProgressGlowCircle({super.key, required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter.w,
      height: diameter.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorPalette.textOnDark.withValues(alpha: 0.08),
      ),
    );
  }
}

/// Translucent pill for secondary facts on the gradient card.
class ProgressFrostedPill extends StatelessWidget {
  const ProgressFrostedPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColorPalette.frostedOnImage,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColorPalette.textOnDark),
      ),
    );
  }
}

/// All-done state: icon plus label so completion is never conveyed by color
/// alone.
class ProgressAllDonePill extends StatelessWidget {
  const ProgressAllDonePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceWhite,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_circle,
            size: 16.r,
            color: AppColorPalette.successGreen,
          ),
          SizedBox(width: 6.w),
          Text(
            AppStrings.allDoneTitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColorPalette.successInk,
            ),
          ),
        ],
      ),
    );
  }
}
