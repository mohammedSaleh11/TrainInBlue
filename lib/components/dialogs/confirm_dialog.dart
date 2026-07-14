import 'package:flutter/material.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../app_theme/theme_extension.dart';

/// Confirmation dialog for destructive actions (delete, reset).
///
/// Returns true only when the user explicitly confirms; dismissing the
/// dialog any other way changes nothing.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      final CustomColors colors = Theme.of(
        dialogContext,
      ).extension<CustomColors>()!;
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            key: AppKeys.confirmDialogCancel,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            key: AppKeys.confirmDialogConfirm,
            style: FilledButton.styleFrom(backgroundColor: colors.destructive),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
