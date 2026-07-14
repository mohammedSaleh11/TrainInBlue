import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;

  /// Stable key applied to the inner field for widget tests.
  final Key? fieldKey;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        TextFormField(
          key: fieldKey,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(hintText: hint),
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
    this.validator,
    this.fieldKey,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      validator: validator,
      fieldKey: fieldKey,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      textCapitalization: TextCapitalization.none,
    );
  }
}
