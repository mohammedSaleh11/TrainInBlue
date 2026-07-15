import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// One rounded segment per set — fills as sets are tracked.
class SegmentedSetProgress extends StatelessWidget {
  const SegmentedSetProgress({
    super.key,
    required this.total,
    required this.done,
  });

  final int total;
  final int done;

  @override
  Widget build(BuildContext context) {
    final bool allDone = total > 0 && done >= total;
    final Color fill = allDone
        ? AppColorPalette.successGreen
        : AppColorPalette.primaryBlue;
    return Row(
      children: <Widget>[
        for (int i = 0; i < total; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < total - 1 ? 6.w : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                height: 6.h,
                decoration: BoxDecoration(
                  color: i < done ? fill : AppColorPalette.iceBackground,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tactile circular set counter: gradient when done, highlighted when next.
class SetDot extends StatelessWidget {
  const SetDot({
    super.key,
    required this.number,
    required this.isDone,
    required this.isCurrent,
    required this.onTap,
  });

  final int number;
  final bool isDone;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: 54.r,
          height: 54.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDone
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      AppColorPalette.primaryBlue,
                      AppColorPalette.primaryBlueDark,
                    ],
                  )
                : null,
            color: isDone
                ? null
                : isCurrent
                ? AppColorPalette.surfaceWhite
                : AppColorPalette.iceBackground,
            border: isDone
                ? null
                : Border.all(
                    color: isCurrent
                        ? AppColorPalette.primaryBlue
                        : AppColorPalette.outlineSoft,
                    width: isCurrent ? 1.8 : 1.2,
                  ),
            boxShadow: isDone
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColorPalette.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 12.r,
                      offset: Offset(0, 5.h),
                    ),
                  ]
                : isCurrent
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColorPalette.primaryBlue.withValues(
                        alpha: 0.14,
                      ),
                      blurRadius: 10.r,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : null,
          ),
          child: isDone
              ? Icon(
                  Icons.check_rounded,
                  size: 22.r,
                  color: AppColorPalette.textOnDark,
                )
              : Text(
                  '$number',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isCurrent
                        ? AppColorPalette.primaryBlueDark
                        : AppColorPalette.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}
