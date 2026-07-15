import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/colors.dart';
import 'confirm_dialog_card.dart';

/// Confirmation dialog for destructive actions (delete, reset).
///
/// Returns true only when the user explicitly confirms; dismissing the
/// dialog any other way changes nothing.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  IconData icon = Icons.delete_outline_rounded,
}) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    barrierColor: AppColorPalette.deepNavy.withValues(alpha: 0.55),
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: ConfirmDialogCard(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          icon: icon,
        ),
      );
    },
  );
  return confirmed ?? false;
}
