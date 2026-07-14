import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// Elevated white panel for detail-screen sections — shadow, border, and an
/// optional titled header with a gradient icon tile.
class DetailPanel extends StatelessWidget {
  const DetailPanel({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.trailing,
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
          BoxShadow(
            color: AppColorPalette.deepNavy.withValues(alpha: 0.04),
            blurRadius: 4.r,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Material(
        color: AppColorPalette.surfaceWhite,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
          side: const BorderSide(color: AppColorPalette.outlineSoft),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null || icon != null) ...<Widget>[
                Row(
                  children: <Widget>[
                    if (icon != null) ...<Widget>[
                      _HeaderIcon(icon: icon!),
                      SizedBox(width: 12.w),
                    ],
                    if (title != null)
                      Expanded(
                        child: Text(title!, style: textTheme.titleMedium),
                      )
                    else
                      const Spacer(),
                    ?trailing,
                  ],
                ),
                SizedBox(height: 16.h),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            AppColorPalette.primaryBlue,
            AppColorPalette.primaryBlueDark,
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, size: 18.r, color: AppColorPalette.textOnDark),
    );
  }
}
