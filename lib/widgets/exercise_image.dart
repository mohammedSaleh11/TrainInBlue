import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Core/constants/app_assets.dart';
import '../Core/constants/colors.dart';

/// Exercise photo that resolves a bundled asset path before loading, then
/// falls back to the category image or a neutral placeholder — never the
/// red asset error box.
class ExerciseImage extends StatefulWidget {
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
  State<ExerciseImage> createState() => _ExerciseImageState();
}

class _ExerciseImageState extends State<ExerciseImage> {
  String? _resolvedPath;
  bool _resolved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvePath();
  }

  @override
  void didUpdateWidget(covariant ExerciseImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name ||
        oldWidget.category != widget.category) {
      _resolved = false;
      _resolvePath();
    }
  }

  Future<void> _resolvePath() async {
    final AssetBundle bundle = DefaultAssetBundle.of(context);
    final String primary = AppAssets.exerciseImage(
      widget.name,
      widget.category,
    );
    final String fallback = AppAssets.categoryThumbnail(widget.category);
    String? path;
    for (final String candidate in <String>{primary, fallback}) {
      try {
        await bundle.load(candidate);
        path = candidate;
        break;
      } on Object {
        continue;
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _resolvedPath = path;
      _resolved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = !_resolved
        ? _placeholder()
        : _resolvedPath == null
        ? _placeholder()
        : Image.asset(
            _resolvedPath!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            width: widget.expand ? null : widget.width,
            height: widget.expand ? null : widget.height,
          );

    if (widget.expand) {
      return SizedBox.expand(child: child);
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: child,
    );
  }

  Widget _placeholder() {
    final double iconSize = widget.expand ? 72.r : (widget.width ?? 56.w) * 0.42;
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
