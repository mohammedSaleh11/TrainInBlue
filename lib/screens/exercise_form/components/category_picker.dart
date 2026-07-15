import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/exercise_draft_validator.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../components/Inputs/app_text_field.dart';
import 'category_chip.dart';
import 'category_chip_group.dart';

/// Chip-first category selection. Presets update instantly; Custom reveals
/// a text field only when a free-form category is needed.
class CategoryPicker extends StatefulWidget {
  const CategoryPicker({
    super.key,
    required this.controller,
    this.onCategoryCommitted,
  });

  static const List<String> suggestions = <String>[
    'Legs',
    'Chest',
    'Back',
    'Core',
    'Cardio',
    'Full Body',
  ];

  final TextEditingController controller;
  final ValueChanged<String>? onCategoryCommitted;

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  late bool _customMode;
  final FocusNode _customFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _customMode = _isCustomValue(widget.controller.text);
    widget.controller.addListener(_syncFromController);
    _customFocus.addListener(_onCustomFocusChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncFromController);
    _customFocus.removeListener(_onCustomFocusChange);
    _customFocus.dispose();
    super.dispose();
  }

  bool _isCustomValue(String value) {
    final String normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    return !CategoryPicker.suggestions.any(
      (String s) => s.toLowerCase() == normalized,
    );
  }

  void _syncFromController() {
    final bool next = _isCustomValue(widget.controller.text);
    if (next != _customMode && mounted) setState(() => _customMode = next);
  }

  void _selectPreset(String category) {
    formSelectionHaptic();
    setState(() => _customMode = false);
    widget.controller.text = category;
    _customFocus.unfocus();
    widget.onCategoryCommitted?.call(category);
  }

  void _selectCustom() {
    formSelectionHaptic();
    setState(() => _customMode = true);
    if (!_isCustomValue(widget.controller.text)) widget.controller.clear();
    // Use the branded form hero while composing a custom category.
    widget.onCategoryCommitted?.call('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _customFocus.requestFocus();
    });
  }

  void _commitCustom() {
    // Keep the standard form hero for free-form categories.
    widget.onCategoryCommitted?.call('');
  }

  void _onCustomFocusChange() {
    if (!_customFocus.hasFocus && _customMode) _commitCustom();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: AppKeys.categoryField,
      initialValue: widget.controller.text.trim(),
      validator: (_) =>
          ExerciseDraftValidator.validateCategory(widget.controller.text),
      builder: (FormFieldState<String> field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const CategoryPickerHint(),
          SizedBox(height: 14.h),
          CategoryChipGroup(
            suggestions: CategoryPicker.suggestions,
            selected: widget.controller.text.trim(),
            customMode: _customMode,
            onPresetSelected: (String category) {
              _selectPreset(category);
              field.didChange(category);
            },
            onCustomSelected: () {
              _selectCustom();
              field.didChange(widget.controller.text);
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _customMode
                ? Padding(
                    padding: EdgeInsetsDirectional.only(top: 14.h),
                    child: AppTextField(
                      controller: widget.controller,
                      label: '',
                      hint: AppStrings.categoryHint,
                      focusNode: _customFocus,
                      fillColor: AppColorPalette.iceBackground,
                      validator: ExerciseDraftValidator.validateCategory,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: field.didChange,
                      onEditingComplete: _commitCustom,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
