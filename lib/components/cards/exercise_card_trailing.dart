import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../app_theme/theme_extension.dart';
import '../../data/models/exercise.dart';

/// Edit/delete overflow menu for a single exercise card.
class ExerciseActionsMenu extends StatelessWidget {
  const ExerciseActionsMenu({
    super.key,
    required this.exercise,
    required this.onEdit,
    required this.onDelete,
  });

  final Exercise exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final CustomColors colors = Theme.of(context).extension<CustomColors>()!;
    return PopupMenuButton<String>(
      key: AppKeys.exerciseMenu(exercise.id),
      tooltip: 'Exercise actions',
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: 32.w, height: 32.w),
      icon: Icon(
        Icons.more_horiz_rounded,
        size: 22.r,
        color: AppColorPalette.textMuted,
      ),
      onSelected: (String action) {
        if (action == 'edit') {
          onEdit();
        } else if (action == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Text(AppStrings.edit),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            AppStrings.delete,
            style: TextStyle(color: colors.destructive),
          ),
        ),
      ],
    );
  }
}

/// Subtle drag affordance along the card bottom edge.
class ExerciseCardDragHandle extends StatelessWidget {
  const ExerciseCardDragHandle({
    super.key,
    required this.exercise,
    required this.reorderIndex,
  });

  final Exercise exercise;
  final int reorderIndex;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      key: AppKeys.dragHandle(exercise.id),
      index: reorderIndex,
      child: Semantics(
        label: AppStrings.reorderHint,
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 10.w,
            vertical: 6.h,
          ),
          decoration: BoxDecoration(
            color: AppColorPalette.surfaceTintBlue.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.drag_indicator_rounded,
                size: 18.r,
                color: AppColorPalette.textMuted,
              ),
              SizedBox(width: 4.w),
              Text(
                AppStrings.reorderHint,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColorPalette.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
