import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../components/buttons/primary_action_button.dart';

/// Pinned save action with a soft elevation over the form sheet.
class ExerciseFormSaveBar extends StatelessWidget {
  const ExerciseFormSaveBar({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceWhite,
        border: const Border(
          top: BorderSide(color: AppColorPalette.outlineSoft),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.deepNavy.withValues(alpha: 0.1),
            blurRadius: 20.r,
            offset: Offset(0, -6.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 16.h),
          child: PrimaryActionButton(
            key: AppKeys.saveExerciseButton,
            label: AppStrings.saveExercise,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
