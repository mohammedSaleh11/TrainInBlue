import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/colors.dart';
import '../../screens/exercise_form/components/required_badge.dart';

/// Labeled text field with the app's shared decoration and validation hookup.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.fieldKey,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.focusNode,
    this.fillColor,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction,
    this.required = false,
    this.labelMaxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final Key? fieldKey;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final Color? fillColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool required;
  final int labelMaxLines;

  @override
  Widget build(BuildContext context) {
    final Color fill = fillColor ?? AppColorPalette.iceBackground;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label.isNotEmpty) ...<Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  maxLines: labelMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (required) ...<Widget>[
                SizedBox(width: 8.w),
                const RequiredBadge(),
              ],
            ],
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          key: fieldKey,
          controller: controller,
          focusNode: focusNode,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: fill,
            hoverColor: fill,
            focusColor: fill,
          ),
        ),
      ],
    );
  }
}

/// Digits-only variant for sets, repetitions, and duration inputs.
class AppNumberField extends StatelessWidget {
  const AppNumberField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.fieldKey,
    this.fillColor,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final Key? fieldKey;
  final Color? fillColor;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      validator: validator,
      fieldKey: fieldKey,
      fillColor: fillColor,
      required: required,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      textCapitalization: TextCapitalization.none,
    );
  }
}
