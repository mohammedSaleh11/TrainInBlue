import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// Deep navy-to-blue gradient with soft decorative glow circles, used as the
/// backdrop of the splash screen.
class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: <Color>[
            AppColorPalette.deepNavy,
            AppColorPalette.primaryBlueDark,
            AppColorPalette.primaryBlue,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: const AlignmentDirectional(-1.6, -1.1),
            child: _SoftCircle(diameter: 280.r, opacity: 0.07),
          ),
          Align(
            alignment: const AlignmentDirectional(1.7, -0.35),
            child: _SoftCircle(diameter: 200.r, opacity: 0.09),
          ),
          Align(
            alignment: const AlignmentDirectional(-1.2, 1.25),
            child: _SoftCircle(diameter: 320.r, opacity: 0.06),
          ),
          child,
        ],
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.diameter, required this.opacity});

  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorPalette.textOnDark.withValues(alpha: opacity),
      ),
    );
  }
}
