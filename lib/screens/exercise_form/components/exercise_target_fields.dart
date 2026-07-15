import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/exercise_draft_validator.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../components/Inputs/app_text_field.dart';
import '../../../data/models/exercise_target_type.dart';
import 'category_chip.dart';
import 'target_type_toggle.dart';

/// Target section: repetitions/duration toggle plus sets and target inputs.
class ExerciseTargetFields extends StatelessWidget {
  const ExerciseTargetFields({
    super.key,
    required this.targetType,
    required this.onTargetTypeChanged,
    required this.setsController,
    required this.repetitionsController,
    required this.durationController,
    this.showSectionLabel = true,
  });

  final ExerciseTargetType targetType;
  final ValueChanged<ExerciseTargetType> onTargetTypeChanged;
  final TextEditingController setsController;
  final TextEditingController repetitionsController;
  final TextEditingController durationController;
  final bool showSectionLabel;

  @override
  Widget build(BuildContext context) {
    final bool usesReps = targetType == ExerciseTargetType.repetitions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showSectionLabel) ...<Widget>[
          Text(
            AppStrings.targetTypeLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 10.h),
        ],
        TargetTypeToggle(
          targetType: targetType,
          onChanged: (ExerciseTargetType type) {
            formSelectionHaptic();
            onTargetTypeChanged(type);
          },
        ),
        SizedBox(height: 10.h),
        Text(
          AppStrings.targetFieldsHint,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColorPalette.textMuted),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AppNumberField(
                controller: setsController,
                label: AppStrings.setsLabel,
                hint: AppStrings.setsHint,
                fieldKey: AppKeys.setsField,
                fillColor: AppColorPalette.iceBackground,
                validator: ExerciseDraftValidator.validateSets,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: AppNumberField(
                  key: ValueKey<ExerciseTargetType>(targetType),
                  controller: usesReps
                      ? repetitionsController
                      : durationController,
                  label: usesReps
                      ? AppStrings.repetitionsLabel
                      : AppStrings.durationLabel,
                  hint: usesReps
                      ? AppStrings.repetitionsHint
                      : AppStrings.durationHint,
                  fieldKey: usesReps
                      ? AppKeys.repetitionsField
                      : AppKeys.durationField,
                  fillColor: AppColorPalette.iceBackground,
                  validator: usesReps
                      ? ExerciseDraftValidator.validateRepetitions
                      : ExerciseDraftValidator.validateDurationSeconds,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
