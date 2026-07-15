import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise_target_type.dart';

/// Repetitions / Duration segmented control for the exercise form.
class TargetTypeToggle extends StatelessWidget {
  const TargetTypeToggle({
    super.key,
    required this.targetType,
    required this.onChanged,
  });

  final ExerciseTargetType targetType;
  final ValueChanged<ExerciseTargetType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: AppKeys.targetTypeSelector,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColorPalette.iceBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColorPalette.outlineSoft),
      ),
      child: Row(
        children: ExerciseTargetType.values
            .map((ExerciseTargetType type) {
              final bool selected = type == targetType;
              return Expanded(
                child: Material(
                  color: selected
                      ? AppColorPalette.primaryBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                  elevation: selected ? 2 : 0,
                  shadowColor: AppColorPalette.primaryBlue.withValues(
                    alpha: 0.35,
                  ),
                  child: InkWell(
                    onTap: () => onChanged(type),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (selected) ...<Widget>[
                            Icon(
                              Icons.check_rounded,
                              size: 16.r,
                              color: AppColorPalette.textOnDark,
                            ),
                            SizedBox(width: 6.w),
                          ],
                          Text(
                            type.label,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? AppColorPalette.textOnDark
                                  : AppColorPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
