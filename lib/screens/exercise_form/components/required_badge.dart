import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Compact "Required" pill used on form section headers and field labels.
class RequiredBadge extends StatelessWidget {
  const RequiredBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceTintBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        AppStrings.requiredBadge,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColorPalette.primaryBlue,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
