import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/exercise_image.dart';
import 'detail_hero_parts.dart';

/// Full-bleed hero: exercise photo with dual gradients, frosted controls,
/// and title/category anchored to the bottom.
class ExerciseDetailHero extends StatelessWidget {
  const ExerciseDetailHero({
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadiusDirectional.only(
        bottomStart: Radius.circular(32.r),
        bottomEnd: Radius.circular(32.r),
      ),
      child: SizedBox(
        height: 380.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'exercise-image-${exercise.id}',
              child: ExerciseImage(
                name: exercise.name,
                category: exercise.category,
                expand: true,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: <double>[0.0, 0.35, 0.75, 1.0],
                  colors: <Color>[
                    Color(0x990A1E4A),
                    Colors.transparent,
                    Color(0x330A1E4A),
                    AppColorPalette.heroScrim,
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.w, 8.h, 12.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DetailHeroIconButton(
                      key: AppKeys.detailBackButton,
                      icon: Icons.arrow_back_rounded,
                      tooltip: AppStrings.back,
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    DetailHeroMenu(onEdit: onEdit, onDelete: onDelete),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 28.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: <Widget>[
                        DetailHeroCategoryChip(label: exercise.category),
                        if (exercise.isCompleted)
                          const DetailHeroCompletedChip(),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      exercise.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColorPalette.textOnDark,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
