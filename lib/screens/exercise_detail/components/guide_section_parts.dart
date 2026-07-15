import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          width: 30.r,
          height: 30.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColorPalette.surfaceTintBlue,
                AppColorPalette.primaryBlue.withValues(alpha: 0.18),
              ],
            ),
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
            child: Text(
              text,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: AppColorPalette.textSecondary,
              ),
            ),
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
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 28.r,
            height: 28.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColorPalette.surfaceTintBlue,
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 15.r,
              color: AppColorPalette.primaryBlue,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 4.h),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: AppColorPalette.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
