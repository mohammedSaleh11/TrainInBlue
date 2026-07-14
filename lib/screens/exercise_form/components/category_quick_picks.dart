import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/colors.dart';

/// One-tap suggestions that fill the category field; free text remains
/// possible for custom categories.
class CategoryQuickPicks extends StatelessWidget {
  const CategoryQuickPicks({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  static const List<String> suggestions = <String>[
    'Legs',
    'Chest',
    'Back',
    'Core',
    'Cardio',
    'Full Body',
  ];

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final String normalized = selectedCategory.trim().toLowerCase();
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: suggestions
          .map((String category) {
            final bool isSelected = category.toLowerCase() == normalized;
            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onSelected(category),
              selectedColor: AppColorPalette.primaryBlue,
              backgroundColor: AppColorPalette.surfaceWhite,
              labelStyle: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColorPalette.textOnDark
                    : AppColorPalette.textSecondary,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColorPalette.primaryBlue
                    : AppColorPalette.outlineSoft,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              showCheckmark: false,
            );
          })
          .toList(growable: false),
    );
  }
}
