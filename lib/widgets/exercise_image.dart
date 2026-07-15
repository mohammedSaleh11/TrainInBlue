import 'package:flutter/material.dart';

import '../Core/constants/app_assets.dart';
import '../Core/constants/colors.dart';

/// Exercise photo resolved synchronously from [AppAssets], with a calm
/// placeholder only if the bundled asset fails to decode.
///
/// Decodes at display resolution ([cacheWidth]/[cacheHeight]) so large studio
/// photos do not stay fully resident in memory on every list card.
class ExerciseImage extends StatelessWidget {
  const ExerciseImage({
    super.key,
    required this.name,
    required this.category,
    this.width,
    this.height,
    this.expand = false,
  });

  final String name;
  final String category;
  final double? width;
  final double? height;

  /// When true, fills the parent (for hero headers). Do not pass infinity
  /// as width/height — use this flag instead.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final String path = AppAssets.exerciseImage(name, category);
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    final Size screen = MediaQuery.sizeOf(context);
    final int? cacheWidth = expand
        ? (screen.width * dpr).round()
        : width != null
        ? (width! * dpr).round()
        : null;
    final int? cacheHeight = expand
        ? null
        : height != null
        ? (height! * dpr).round()
        : null;

    final Widget image = Image.asset(
      path,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      width: expand ? null : width,
      height: expand ? null : height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        return _placeholder(context);
      },
    );

    if (expand) {
      return SizedBox.expand(child: image);
    }
    return SizedBox(width: width, height: height, child: image);
  }

  Widget _placeholder(BuildContext context) {
    final double iconSize = expand
        ? 72
        : (width ?? 56) * 0.42;
    return ColoredBox(
      color: AppColorPalette.surfaceTintBlue,
      child: Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: iconSize,
          color: AppColorPalette.primaryBlue,
        ),
      ),
    );
  }
}
