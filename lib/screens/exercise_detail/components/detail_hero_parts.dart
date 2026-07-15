import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Frosted circular icon button for the detail hero toolbar.
class DetailHeroIconButton extends StatelessWidget {
  const DetailHeroIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.25),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.deepNavy.withValues(alpha: 0.2),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Material(
        color: AppColorPalette.frostedOnImage,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          icon: Icon(icon, color: AppColorPalette.textOnDark, size: 22.r),
        ),
      ),
    );
  }
}

/// Edit/delete overflow on the detail hero.
class DetailHeroMenu extends StatelessWidget {
  const DetailHeroMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.25),
        ),
      ),
      child: Material(
        color: AppColorPalette.frostedOnImage,
        shape: const CircleBorder(),
        child: PopupMenuButton<String>(
          key: AppKeys.detailMenuButton,
          tooltip: 'Exercise options',
          icon: Icon(
            Icons.more_horiz,
            color: AppColorPalette.textOnDark,
            size: 22.r,
          ),
          onSelected: (String action) =>
              action == 'edit' ? onEdit() : onDelete(),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              key: AppKeys.detailEditMenuItem,
              value: 'edit',
              child: Text(AppStrings.edit),
            ),
            const PopupMenuItem<String>(
              key: AppKeys.detailDeleteMenuItem,
              value: 'delete',
              child: Text(AppStrings.delete),
            ),
          ],
        ),
      ),
    );
  }
}
