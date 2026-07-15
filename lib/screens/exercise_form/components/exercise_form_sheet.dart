import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../Core/Utils/exercise_draft_validator.dart';
import '../../../components/Inputs/app_text_field.dart';
import '../../../data/models/exercise_target_type.dart';
import '../../exercise_detail/components/detail_panel.dart';
import 'category_picker.dart';
import 'exercise_target_fields.dart';
import 'required_badge.dart';

/// Form body under the hero — generous spacing so the curved image can breathe.
class ExerciseFormSheet extends StatelessWidget {
  const ExerciseFormSheet({
    super.key,
    required this.nameController,
    required this.categoryController,
    required this.setsController,
    required this.repetitionsController,
    required this.durationController,
    required this.targetType,
    required this.onTargetTypeChanged,
    this.onCategoryCommitted,
  });

  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController setsController;
  final TextEditingController repetitionsController;
  final TextEditingController durationController;
  final ExerciseTargetType targetType;
  final ValueChanged<ExerciseTargetType> onTargetTypeChanged;
  final ValueChanged<String>? onCategoryCommitted;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorPalette.iceBackground,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 28.h, 20.w, 36.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColorPalette.outlineSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 22.h),
            DetailPanel(
              title: AppStrings.nameLabel,
              icon: Icons.fitness_center_rounded,
              trailing: const RequiredBadge(),
              child: AppTextField(
                controller: nameController,
                label: '',
                hint: AppStrings.nameHint,
                fieldKey: AppKeys.nameField,
                fillColor: AppColorPalette.iceBackground,
                validator: ExerciseDraftValidator.validateName,
              ),
            ),
            SizedBox(height: 18.h),
            DetailPanel(
              title: AppStrings.categoryLabel,
              icon: Icons.category_rounded,
              trailing: const RequiredBadge(),
              child: CategoryPicker(
                controller: categoryController,
                onCategoryCommitted: onCategoryCommitted,
              ),
            ),
            SizedBox(height: 18.h),
            DetailPanel(
              title: AppStrings.targetTypeLabel,
              icon: Icons.tune_rounded,
              trailing: const RequiredBadge(),
              child: ExerciseTargetFields(
                targetType: targetType,
                onTargetTypeChanged: onTargetTypeChanged,
                setsController: setsController,
                repetitionsController: repetitionsController,
                durationController: durationController,
                showSectionLabel: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
