import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/exercise_image_hero.dart';
import 'detail_hero_chips.dart';
import 'detail_hero_parts.dart';
import 'detail_hero_stats.dart';

/// Full-bleed hero: exercise photo under a cinematic scrim with frosted
/// controls, title block, and a glass stat bar anchored to the bottom.
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
    final double topInset = MediaQuery.viewPaddingOf(context).top;
    return SizedBox(
      height: 340.h + topInset,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(36.r),
          bottomEnd: Radius.circular(36.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ExerciseImageHero(
              exerciseId: exercise.id,
              name: exercise.name,
              category: exercise.category,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(36.r),
                bottomEnd: Radius.circular(36.r),
              ).resolve(Directionality.of(context)),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: <double>[0.0, 0.26, 0.58, 1.0],
                  colors: <Color>[
                    Color(0xB30A1E4A),
                    Color(0x0F0A1E4A),
                    Color(0x6E0A1E4A),
                    Color(0xD90A1E4A),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                12.w,
                topInset + 8.h,
                12.w,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 22.h),
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
                    SizedBox(height: 14.h),
                    Text(
                      exercise.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColorPalette.textOnDark,
                        height: 1.1,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    DetailHeroStats(exercise: exercise),
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
