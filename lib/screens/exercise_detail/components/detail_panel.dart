import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// Soft elevated surface for detail sections — quiet shadow, no loud chrome.
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
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.deepNavy.withValues(alpha: 0.06),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Material(
        color: AppColorPalette.surfaceWhite,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(
            color: AppColorPalette.outlineSoft.withValues(alpha: 0.85),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(20.w),
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
                        child: Text(
                          title!,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    ?trailing,
                  ],
                ),
                SizedBox(height: 18.h),
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
        color: AppColorPalette.surfaceTintBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, size: 18.r, color: AppColorPalette.primaryBlueDark),
    );
  }
}
