import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Core/constants/colors.dart';

/// Animated page dots: the active dot stretches into a rounded pill.
class DotPageIndicator extends StatelessWidget {
  const DotPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${currentPage + 1} of $pageCount',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(pageCount, (int index) {
          final bool isActive = index == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
            width: isActive ? 28.w : 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColorPalette.primaryBlue
                  : AppColorPalette.outlineSoft,
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }
}
