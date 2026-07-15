import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// Compact set-progress chip for the duration timer header.
class DurationTimerSetPill extends StatelessWidget {
  const DurationTimerSetPill({
    super.key,
    required this.label,
    required this.done,
  });

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: done
            ? AppColorPalette.successSurface
            : AppColorPalette.surfaceTintBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: done
              ? AppColorPalette.successInk
              : AppColorPalette.primaryBlueDark,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
