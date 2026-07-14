import 'package:flutter/material.dart';

import '../Core/constants/colors.dart';
import 'app_typography.dart';
import 'theme_extension.dart';

/// Builds the TrainInBlue Material 3 theme: vivid athletic blue paired with
/// deep navy text, soft ice-blue surfaces, and rounded, generously sized
/// components with accessible tap targets.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final ColorScheme scheme =
        ColorScheme.fromSeed(seedColor: AppColorPalette.primaryBlue).copyWith(
          primary: AppColorPalette.primaryBlue,
          onPrimary: AppColorPalette.textOnDark,
          secondary: AppColorPalette.skyBlue,
          surface: AppColorPalette.surfaceWhite,
          onSurface: AppColorPalette.textPrimary,
          onSurfaceVariant: AppColorPalette.textSecondary,
          outline: AppColorPalette.outlineSoft,
          outlineVariant: AppColorPalette.outlineSoft,
          error: AppColorPalette.destructiveRed,
        );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: AppColorPalette.iceBackground,
    );

    return base.copyWith(
      textTheme: AppTypography.textTheme(base.textTheme),
      extensions: const <ThemeExtension<dynamic>>[CustomColors.light],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColorPalette.textPrimary,
      ),
      cardTheme: CardThemeData(
        color: AppColorPalette.surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorPalette.primaryBlue,
          foregroundColor: AppColorPalette.textOnDark,
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorPalette.primaryBlue,
          minimumSize: const Size(64, 52),
          side: const BorderSide(color: AppColorPalette.primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorPalette.primaryBlue,
          minimumSize: const Size(48, 48),
          textStyle: AppTypography.button.copyWith(fontSize: 15),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColorPalette.primaryBlue,
        foregroundColor: AppColorPalette.textOnDark,
        extendedTextStyle: AppTypography.button,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorPalette.surfaceWhite,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: _inputBorder(AppColorPalette.outlineSoft),
        enabledBorder: _inputBorder(AppColorPalette.outlineSoft),
        focusedBorder: _inputBorder(AppColorPalette.primaryBlue, width: 1.6),
        errorBorder: _inputBorder(AppColorPalette.destructiveRed),
        focusedErrorBorder: _inputBorder(
          AppColorPalette.destructiveRed,
          width: 1.6,
        ),
        labelStyle: const TextStyle(color: AppColorPalette.textSecondary),
        hintStyle: const TextStyle(color: AppColorPalette.textMuted),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColorPalette.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColorPalette.deepNavy,
        contentTextStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 14,
          color: AppColorPalette.textOnDark,
        ),
        actionTextColor: AppColorPalette.skyBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColorPalette.surfaceWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 15,
          color: AppColorPalette.textPrimary,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: AppColorPalette.primaryBlue,
          selectedForegroundColor: AppColorPalette.textOnDark,
          foregroundColor: AppColorPalette.textSecondary,
          side: const BorderSide(color: AppColorPalette.outlineSoft),
          textStyle: AppTypography.button.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColorPalette.primaryBlue,
        linearTrackColor: AppColorPalette.surfaceTintBlue,
        circularTrackColor: AppColorPalette.surfaceTintBlue,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColorPalette.outlineSoft,
        thickness: 1,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
