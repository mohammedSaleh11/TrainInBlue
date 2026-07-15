import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';

/// Premium confirm card: icon badge, clear copy, and full-width actions.
class ConfirmDialogCard extends StatelessWidget {
  const ConfirmDialogCard({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.icon = Icons.delete_outline_rounded,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Material(
      color: AppColorPalette.surfaceWhite,
      borderRadius: BorderRadius.circular(28.r),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(22.w, 26.h, 22.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ConfirmWarningBadge(),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                height: 1.25,
                color: AppColorPalette.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColorPalette.textSecondary,
                height: 1.45,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: FilledButton.icon(
                key: AppKeys.confirmDialogConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColorPalette.destructiveRed,
                  foregroundColor: AppColorPalette.textOnDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(icon, size: 20.r),
                label: Text(
                  confirmLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: TextButton.icon(
                key: AppKeys.confirmDialogCancel,
                style: TextButton.styleFrom(
                  foregroundColor: AppColorPalette.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.close_rounded, size: 18.r),
                label: const Text(
                  AppStrings.cancel,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft red warning circle used at the top of destructive confirms.
class ConfirmWarningBadge extends StatelessWidget {
  const ConfirmWarningBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68.r,
      height: 68.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorPalette.destructiveSurface,
        border: Border.all(
          color: AppColorPalette.destructiveRed.withValues(alpha: 0.18),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.destructiveRed.withValues(alpha: 0.12),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Icon(
        Icons.warning_amber_rounded,
        size: 32.r,
        color: AppColorPalette.destructiveRed,
      ),
    );
  }
}
