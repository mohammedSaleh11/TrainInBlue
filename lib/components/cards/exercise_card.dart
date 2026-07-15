import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/Utils/duration_formatter.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../data/models/active_exercise_timer.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_target_type.dart';
import 'exercise_card_parts.dart';
import 'exercise_card_trailing.dart';

/// Editorial luxury exercise card — quiet chrome, strong photography.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.reorderIndex,
    required this.onToggleCompletion,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    this.activeTimer,
  });

  final Exercise exercise;
  final int reorderIndex;
  final VoidCallback onToggleCompletion;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ActiveExerciseTimer? activeTimer;

  String get _metaLabel {
    final String setsLabel = AppStrings.exerciseSetsLabel(exercise.sets);
    final String targetLabel =
        exercise.targetType == ExerciseTargetType.repetitions
        ? AppStrings.exerciseRepsLabel(exercise.repetitions ?? 0)
        : '${DurationFormatter.formatSeconds(exercise.durationSeconds ?? 0)} each';
    return AppStrings.exerciseMetaLabel(
      setsLabel: setsLabel,
      targetLabel: targetLabel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool done = exercise.isCompleted;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 280),
      opacity: done ? 0.72 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColorPalette.deepNavy.withValues(alpha: 0.16),
              blurRadius: 32.r,
              offset: Offset(0, 16.h),
            ),
            BoxShadow(
              color: AppColorPalette.deepNavy.withValues(alpha: 0.05),
              blurRadius: 4.r,
              offset: Offset(0, 1.h),
            ),
          ],
        ),
        child: Material(
          color: AppColorPalette.deepNavy,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: InkWell(
            onTap: onOpen,
            splashColor: AppColorPalette.textOnDark.withValues(alpha: 0.06),
            highlightColor: AppColorPalette.textOnDark.withValues(alpha: 0.04),
            child: ExerciseCardHero(
              exercise: exercise,
              title: exercise.name,
              category: exercise.category,
              metaLabel: _metaLabel,
              onToggleCompletion: onToggleCompletion,
              activeTimer: activeTimer,
              actions: ExerciseCardHeroActions(
                exercise: exercise,
                reorderIndex: reorderIndex,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
