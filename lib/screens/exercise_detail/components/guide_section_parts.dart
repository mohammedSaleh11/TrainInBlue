import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

class GuideNumberedStep extends StatelessWidget {
  const GuideNumberedStep({
    super.key,
    required this.number,
    required this.text,
  });

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28.r,
          height: 28.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColorPalette.surfaceTintBlue,
                AppColorPalette.primaryBlue.withValues(alpha: 0.2),
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: textTheme.labelMedium?.copyWith(
              color: AppColorPalette.primaryBlueDark,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: 4.h),
            child: Text(text, style: textTheme.bodyMedium),
          ),
        ),
      ],
    );
  }
}

class GuideTipRow extends StatelessWidget {
  const GuideTipRow({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 8.h),
      padding: EdgeInsetsDirectional.all(12.w),
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceTintBlue.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.tips_and_updates_outlined,
            size: 18.r,
            color: AppColorPalette.primaryBlue,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class GuideEquipmentWrap extends StatelessWidget {
  const GuideEquipmentWrap({super.key, required this.equipment});

  final List<String> equipment;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (equipment.isEmpty) {
      return Row(
        children: <Widget>[
          Icon(
            Icons.self_improvement_rounded,
            size: 20.r,
            color: AppColorPalette.primaryBlue,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(AppStrings.bodyweightOnly, style: textTheme.bodyMedium),
          ),
        ],
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
              color: AppColorPalette.surfaceTintBlue,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColorPalette.outlineSoft),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.fitness_center_rounded,
                  size: 14.r,
                  color: AppColorPalette.primaryBlueDark,
                ),
                SizedBox(width: 6.w),
                Text(
                  item,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColorPalette.primaryBlueDark,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
