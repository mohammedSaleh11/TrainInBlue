import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/Utils/duration_formatter.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../app_theme/theme_extension.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_target_type.dart';
import 'exercise_card_parts.dart';
import 'exercise_card_trailing.dart';
import 'surface_card.dart';

/// One exercise in the session list — stacked layout, full text, no clipping.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.reorderIndex,
    required this.onToggleCompletion,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final Exercise exercise;
  final int reorderIndex;
  final VoidCallback onToggleCompletion;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _setsLabel =>
      exercise.sets == 1 ? '1 set' : '${exercise.sets} sets';

  String get _perSetLabel {
    final String target = exercise.targetType == ExerciseTargetType.repetitions
        ? '${exercise.repetitions} reps'
        : DurationFormatter.formatSeconds(exercise.durationSeconds ?? 0);
    return AppStrings.perSetLabel(target);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool done = exercise.isCompleted;
    final CustomColors colors = Theme.of(context).extension<CustomColors>()!;

    return SurfaceCard(
      onTap: onOpen,
      showAccentStripe: false,
      accentColor: done ? colors.success : AppColorPalette.primaryBlue,
      backgroundColor: done
          ? colors.successSurface.withValues(alpha: 0.42)
          : AppColorPalette.surfaceWhite,
      contentPadding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 12.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  exercise.name,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.15,
                    color: done
                        ? AppColorPalette.textSecondary
                        : AppColorPalette.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ExerciseCompletionRing(
                exercise: exercise,
                onPressed: onToggleCompletion,
              ),
              ExerciseActionsMenu(
                exercise: exercise,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ExerciseCardPhoto(exercise: exercise),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExerciseCategoryTag(label: exercise.category),
                    SizedBox(height: 12.h),
                    ExerciseStatLine(
                      icon: Icons.layers_outlined,
                      label: _setsLabel,
                    ),
                    SizedBox(height: 8.h),
                    ExerciseStatLine(
                      icon: exercise.targetType ==
                              ExerciseTargetType.repetitions
                          ? Icons.repeat_rounded
                          : Icons.timer_outlined,
                      label: _perSetLabel,
                    ),
                    if (exercise.targetType == ExerciseTargetType.repetitions)
                      ExerciseSetProgress(
                        completedSets: exercise.completedSets,
                        totalSets: exercise.sets,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ExerciseCardDragHandle(
              exercise: exercise,
              reorderIndex: reorderIndex,
            ),
          ),
        ],
      ),
    );
  }
}
