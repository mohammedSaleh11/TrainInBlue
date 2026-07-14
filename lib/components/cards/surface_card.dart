import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/colors.dart';

/// Elevated white surface with a soft blue shadow and an optional start-edge
/// accent stripe — the shared shell for list cards on the workout home.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.accentColor = AppColorPalette.primaryBlue,
    this.opacity = 1,
    this.contentPadding,
    this.showAccentStripe = true,
    this.backgroundColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color accentColor;
  final double opacity;
  final EdgeInsetsDirectional? contentPadding;
  final bool showAccentStripe;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColorPalette.primaryBlue.withValues(alpha: 0.07),
              blurRadius: 20.r,
              offset: Offset(0, 8.h),
            ),
            BoxShadow(
              color: AppColorPalette.deepNavy.withValues(alpha: 0.03),
              blurRadius: 1.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: Material(
          color: backgroundColor ?? AppColorPalette.surfaceWhite,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(color: accentColor.withValues(alpha: 0.12)),
          ),
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: <Widget>[
                if (showAccentStripe)
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4.w, color: accentColor),
                  ),
                Padding(
                  padding:
                      contentPadding ??
                      EdgeInsetsDirectional.fromSTEB(8.w, 12.h, 8.w, 12.h),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
