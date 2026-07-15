import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../app_theme/theme_extension.dart';
import '../../data/models/exercise.dart';

/// Whisper-quiet menu + drag — no glass capsule.
class ExerciseCardHeroActions extends StatelessWidget {
  const ExerciseCardHeroActions({
    super.key,
    required this.exercise,
    required this.reorderIndex,
    required this.onEdit,
    required this.onDelete,
  });

  final Exercise exercise;
  final int reorderIndex;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExerciseActionsMenu(
          exercise: exercise,
          onEdit: onEdit,
          onDelete: onDelete,
        ),
        ExerciseCardDragHandle(
          exercise: exercise,
          reorderIndex: reorderIndex,
        ),
      ],
    );
  }
}

/// Edit/delete overflow — low-contrast icon on media.
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
      tooltip: AppStrings.exerciseActionsTooltip,
      padding: EdgeInsets.zero,
      offset: Offset(0, 8.h),
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: Icon(
          Icons.more_horiz_rounded,
          size: 22.r,
          color: AppColorPalette.textOnDark.withValues(alpha: 0.92),
        ),
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

/// Soft drag grip — present but not loud.
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
        child: Tooltip(
          message: AppStrings.reorderHint,
          child: SizedBox(
            width: 30.w,
            height: 32.w,
            child: Icon(
              Icons.drag_indicator_rounded,
              size: 20.r,
              color: AppColorPalette.textOnDark.withValues(alpha: 0.82),
            ),
          ),
        ),
      ),
    );
  }
}
