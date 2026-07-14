import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_assets.dart';
import '../../../Core/constants/colors.dart';

/// Brand mark with a soft glow that gently pulses behind it.
class PulsingLogo extends StatelessWidget {
  const PulsingLogo({super.key, required this.pulse});

  /// Repeating 0..1 controller that drives the glow strength.
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (BuildContext context, Widget? logo) {
        final double glow = 24 + (pulse.value * 26);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColorPalette.skyBlue.withValues(
                  alpha: 0.35 + (pulse.value * 0.2),
                ),
                blurRadius: glow,
                spreadRadius: 4 + (pulse.value * 6),
              ),
            ],
          ),
          child: logo,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Image.asset(
          AppAssets.appIcon,
          width: 116.w,
          height: 116.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// The "TrainInBlue" wordmark with the brand's sky-blue accent.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle base = TextStyle(
      fontSize: 34.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.4,
      color: AppColorPalette.textOnDark,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: <InlineSpan>[
          const TextSpan(text: 'TrainIn'),
          TextSpan(
            text: 'Blue',
            style: base.copyWith(color: AppColorPalette.skyBlue),
          ),
        ],
      ),
    );
  }
}
