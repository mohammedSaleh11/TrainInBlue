import 'package:flutter/material.dart';

/// Full-width primary call to action used across onboarding, empty states,
/// and forms so every main action looks and behaves the same.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;

  /// Null disables the button (used while a form is invalid).
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Widget button = icon == null
        ? FilledButton(onPressed: onPressed, child: Text(label))
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 20),
            label: Text(label),
          );
    return SizedBox(width: double.infinity, child: button);
  }
}
