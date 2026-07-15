import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Countdown ring with a floating inner dial and remaining-time readout.
class DurationTimerRing extends StatelessWidget {
  const DurationTimerRing({
    super.key,
    required this.consumed,
    required this.finished,
    required this.clock,
  });

  /// Fraction of the countdown already used, 0..1.
  final double consumed;
  final bool finished;
  final String clock;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color ringColor = finished
        ? AppColorPalette.successGreen
        : AppColorPalette.primaryBlue;
    return Container(
      width: 186.r,
      height: 186.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColorPalette.iceBackground,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: ringColor.withValues(alpha: 0.12),
            blurRadius: 28.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: 158.r,
            height: 158.r,
            child: CircularProgressIndicator(
              value: 1 - consumed,
              strokeWidth: 9.r,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColorPalette.outlineSoft,
              color: ringColor,
            ),
          ),
          Container(
            width: 122.r,
            height: 122.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorPalette.surfaceWhite,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColorPalette.deepNavy.withValues(alpha: 0.08),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  clock,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  AppStrings.timerRemainingLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColorPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
