import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Pill list of gear for the exercise, or a friendly bodyweight note.
class GuideEquipmentWrap extends StatelessWidget {
  const GuideEquipmentWrap({super.key, required this.equipment});

  final List<String> equipment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (equipment.isEmpty) {
      return Text(
        AppStrings.bodyweightOnly,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColorPalette.textSecondary,
          height: 1.4,
        ),
      );
    }
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: <Widget>[
        for (final String item in equipment)
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: AppColorPalette.iceBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColorPalette.outlineSoft),
            ),
            child: Text(
              item,
              style: textTheme.labelMedium?.copyWith(
                color: AppColorPalette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
