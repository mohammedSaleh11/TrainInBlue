import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import 'category_chip.dart';

/// Preset + Custom category chip row used by [CategoryPicker].
class CategoryChipGroup extends StatelessWidget {
  const CategoryChipGroup({
    super.key,
    required this.suggestions,
    required this.selected,
    required this.customMode,
    required this.onPresetSelected,
    required this.onCustomSelected,
  });

  final List<String> suggestions;
  final String selected;
  final bool customMode;
  final ValueChanged<String> onPresetSelected;
  final VoidCallback onCustomSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: <Widget>[
        ...suggestions.map((String category) {
          final bool isSelected =
              !customMode && category.toLowerCase() == selected.toLowerCase();
          return CategoryChip(
            label: category,
            selected: isSelected,
            onTap: () => onPresetSelected(category),
          );
        }),
        CategoryChip(
          label: AppStrings.categoryCustom,
          selected: customMode,
          icon: Icons.edit_rounded,
          onTap: onCustomSelected,
        ),
      ],
    );
  }
}

/// Hint text above the category chips.
class CategoryPickerHint extends StatelessWidget {
  const CategoryPickerHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.categoryPickHint,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColorPalette.textMuted),
    );
  }
}
