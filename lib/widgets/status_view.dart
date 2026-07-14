import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Core/constants/colors.dart';

/// Shared layout for empty, error, and recovery states: an illustration or
/// icon, a title, supporting copy, and stacked full-width actions.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.title,
    required this.message,
    this.imageAsset,
    this.icon,
    this.actions = const <Widget>[],
  });

  final String title;
  final String message;

  /// Illustration shown when provided; otherwise [icon] in a tinted circle.
  final String? imageAsset;
  final IconData? icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 32.w,
          vertical: 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (imageAsset != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(28.r),
                child: Image.asset(
                  imageAsset!,
                  width: 190.w,
                  height: 190.w,
                  fit: BoxFit.cover,
                ),
              )
            else if (icon != null)
              Container(
                width: 96.w,
                height: 96.w,
                decoration: const BoxDecoration(
                  color: AppColorPalette.surfaceTintBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 44.r,
                  color: AppColorPalette.primaryBlue,
                ),
              ),
            SizedBox(height: 24.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24.h),
            for (final Widget action in actions) ...<Widget>[
              SizedBox(width: double.infinity, child: action),
              SizedBox(height: 10.h),
            ],
          ],
        ),
      ),
    );
  }
}
