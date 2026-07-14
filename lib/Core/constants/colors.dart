import 'package:flutter/material.dart';

/// Central TrainInBlue color palette.
///
/// Every color used in the app must come from this palette (directly or via
/// the theme) so the blue identity stays consistent and easy to adjust.
class AppColorPalette {
  AppColorPalette._();

  // Brand blues.
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color skyBlue = Color(0xFF60A5FA);
  static const Color deepNavy = Color(0xFF0A1E4A);

  // Surfaces.
  static const Color iceBackground = Color(0xFFF2F6FD);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceTintBlue = Color(0xFFE7EEFB);
  static const Color outlineSoft = Color(0xFFDCE5F3);

  // Text.
  static const Color textPrimary = Color(0xFF0F1F40);
  static const Color textSecondary = Color(0xFF5B6B87);
  static const Color textMuted = Color(0xFF8A97B1);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Feedback.
  static const Color successGreen = Color(0xFF16A34A);
  static const Color successSurface = Color(0xFFE5F6EB);
  static const Color successInk = Color(0xFF14532D);
  static const Color destructiveRed = Color(0xFFDC2626);
  static const Color destructiveSurface = Color(0xFFFCE9E9);

  // Overlays.
  static const Color heroScrim = Color(0xB30A1E4A);
  static const Color frostedOnImage = Color(0x33FFFFFF);
}
