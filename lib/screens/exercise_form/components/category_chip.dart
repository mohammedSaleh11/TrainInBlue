import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// Animated selection chip used by the category picker.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 14.w,
            vertical: 11.h,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppColorPalette.primaryBlue
                : AppColorPalette.surfaceWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected
                  ? AppColorPalette.primaryBlue
                  : AppColorPalette.outlineSoft,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColorPalette.primaryBlue.withValues(
                        alpha: 0.28,
                      ),
                      blurRadius: 12.r,
                      offset: Offset(0, 5.h),
                    ),
                  ]
                : <BoxShadow>[
                    BoxShadow(
                      color: AppColorPalette.deepNavy.withValues(alpha: 0.04),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (selected) ...<Widget>[
                Icon(
                  Icons.check_rounded,
                  size: 15.r,
                  color: AppColorPalette.textOnDark,
                ),
                SizedBox(width: 6.w),
              ] else if (icon != null) ...<Widget>[
                Icon(icon, size: 15.r, color: AppColorPalette.textSecondary),
                SizedBox(width: 6.w),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  color: selected
                      ? AppColorPalette.textOnDark
                      : AppColorPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Light haptic helper shared by form chips / toggles.
void formSelectionHaptic() => HapticFeedback.selectionClick();
