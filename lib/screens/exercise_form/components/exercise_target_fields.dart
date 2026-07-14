import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/exercise_draft_validator.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../components/Inputs/app_text_field.dart';
import '../../../data/models/exercise_target_type.dart';

/// Target section of the exercise form: the repetitions/duration selector,
/// the sets field, and the input for the selected target type only.
class ExerciseTargetFields extends StatelessWidget {
  const ExerciseTargetFields({
    super.key,
    required this.targetType,
    required this.onTargetTypeChanged,
    required this.setsController,
    required this.repetitionsController,
    required this.durationController,
  });

  final ExerciseTargetType targetType;
  final ValueChanged<ExerciseTargetType> onTargetTypeChanged;
  final TextEditingController setsController;
  final TextEditingController repetitionsController;
  final TextEditingController durationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.targetTypeLabel,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ExerciseTargetType>(
            key: AppKeys.targetTypeSelector,
            segments: ExerciseTargetType.values
                .map(
                  (ExerciseTargetType type) =>
                      ButtonSegment<ExerciseTargetType>(
                        value: type,
                        label: Text(type.label),
                      ),
                )
                .toList(growable: false),
            selected: <ExerciseTargetType>{targetType},
            onSelectionChanged: (Set<ExerciseTargetType> selection) =>
                onTargetTypeChanged(selection.first),
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: AppNumberField(
                controller: setsController,
                label: AppStrings.setsLabel,
                fieldKey: AppKeys.setsField,
                validator: ExerciseDraftValidator.validateSets,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: targetType == ExerciseTargetType.repetitions
                  ? AppNumberField(
                      controller: repetitionsController,
                      label: AppStrings.repetitionsLabel,
                      fieldKey: AppKeys.repetitionsField,
                      validator: ExerciseDraftValidator.validateRepetitions,
                    )
                  : AppNumberField(
                      controller: durationController,
                      label: AppStrings.durationLabel,
                      fieldKey: AppKeys.durationField,
                      validator: ExerciseDraftValidator.validateDurationSeconds,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
