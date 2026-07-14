import 'package:flutter/material.dart';

import '../Core/constants/colors.dart';

/// Semantic colors that Material's [ColorScheme] does not cover.
///
/// Read them anywhere with `Theme.of(context).extension<CustomColors>()`.
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.successSurface,
    required this.successInk,
    required this.destructive,
    required this.destructiveSurface,
    required this.chipSurface,
    required this.heroScrim,
  });

  final Color success;
  final Color successSurface;
  final Color successInk;
  final Color destructive;
  final Color destructiveSurface;
  final Color chipSurface;
  final Color heroScrim;

  static const CustomColors light = CustomColors(
    success: AppColorPalette.successGreen,
    successSurface: AppColorPalette.successSurface,
    successInk: AppColorPalette.successInk,
    destructive: AppColorPalette.destructiveRed,
    destructiveSurface: AppColorPalette.destructiveSurface,
    chipSurface: AppColorPalette.surfaceTintBlue,
    heroScrim: AppColorPalette.heroScrim,
  );

  @override
  CustomColors copyWith({
    Color? success,
    Color? successSurface,
    Color? successInk,
    Color? destructive,
    Color? destructiveSurface,
    Color? chipSurface,
    Color? heroScrim,
  }) {
    return CustomColors(
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      successInk: successInk ?? this.successInk,
      destructive: destructive ?? this.destructive,
      destructiveSurface: destructiveSurface ?? this.destructiveSurface,
      chipSurface: chipSurface ?? this.chipSurface,
      heroScrim: heroScrim ?? this.heroScrim,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      successInk: Color.lerp(successInk, other.successInk, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveSurface: Color.lerp(
        destructiveSurface,
        other.destructiveSurface,
        t,
      )!,
      chipSurface: Color.lerp(chipSurface, other.chipSurface, t)!,
      heroScrim: Color.lerp(heroScrim, other.heroScrim, t)!,
    );
  }
}
