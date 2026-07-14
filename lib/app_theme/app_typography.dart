import 'package:flutter/material.dart';

import '../Core/constants/colors.dart';

/// TrainInBlue type scale: Manrope with heavy weights for headings and
/// relaxed line heights for body copy.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Manrope';

  static TextTheme textTheme(TextTheme base) {
    return base
        .apply(
          bodyColor: AppColorPalette.textPrimary,
          displayColor: AppColorPalette.textPrimary,
        )
        .copyWith(
          headlineLarge: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.2,
            color: AppColorPalette.textPrimary,
          ),
          headlineMedium: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            height: 1.25,
            color: AppColorPalette.textPrimary,
          ),
          titleLarge: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColorPalette.textPrimary,
          ),
          titleMedium: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColorPalette.textPrimary,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: AppColorPalette.textSecondary,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            height: 1.45,
            color: AppColorPalette.textSecondary,
          ),
          labelMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColorPalette.textMuted,
          ),
        );
  }

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}
