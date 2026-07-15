import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise_guide.dart';
import 'detail_panel.dart';
import 'guide_equipment_wrap.dart';
import 'guide_section_parts.dart';

/// Coaching content: overview, steps, tips, and equipment.
class ExerciseGuideSections extends StatelessWidget {
  const ExerciseGuideSections({super.key, required this.guide});

  final ExerciseGuide guide;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DetailPanel(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AppColorPalette.primaryBlue,
                        AppColorPalette.skyBlue,
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    guide.summary,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColorPalette.textSecondary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        DetailPanel(
          title: AppStrings.howToPerform,
          icon: Icons.list_alt_rounded,
          child: Column(
            children: <Widget>[
              for (int i = 0; i < guide.steps.length; i++) ...<Widget>[
                GuideNumberedStep(number: i + 1, text: guide.steps[i]),
                if (i < guide.steps.length - 1) SizedBox(height: 14.h),
              ],
            ],
          ),
        ),
        SizedBox(height: 14.h),
        DetailPanel(
          title: AppStrings.coachTips,
          icon: Icons.lightbulb_outline_rounded,
          child: Column(
            children: <Widget>[
              for (final String tip in guide.tips) GuideTipRow(text: tip),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        DetailPanel(
          title: AppStrings.equipmentTitle,
          icon: Icons.inventory_2_outlined,
          child: GuideEquipmentWrap(equipment: guide.equipment),
        ),
      ],
    );
  }
}
