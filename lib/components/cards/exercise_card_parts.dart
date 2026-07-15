import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/constants/colors.dart';
import '../../data/models/active_exercise_timer.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_target_type.dart';
import '../../widgets/exercise_image_hero.dart';
import 'exercise_card_controls.dart';
import 'exercise_card_live_timer.dart';

/// Quiet editorial hero — photography first, restrained typography.
class ExerciseCardHero extends StatelessWidget {
  const ExerciseCardHero({
    super.key,
    required this.exercise,
    required this.title,
    required this.category,
    required this.metaLabel,
    required this.onToggleCompletion,
    required this.actions,
    this.activeTimer,
  });

  final Exercise exercise;
  final String title;
  final String category;
  final String metaLabel;
  final VoidCallback onToggleCompletion;
  final Widget actions;
  final ActiveExerciseTimer? activeTimer;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isDuration =
        exercise.targetType == ExerciseTargetType.duration;

    return SizedBox(
      height: isDuration ? 248.h : 236.h,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ExerciseImageHero(
            exerciseId: exercise.id,
            name: exercise.name,
            category: exercise.category,
            borderRadius: BorderRadius.circular(22.r),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0x660A1E4A),
                  Color(0x140A1E4A),
                  Color(0xCC0A1E4A),
                  Color(0xF50A1E4A),
                ],
                stops: <double>[0, 0.38, 0.72, 1],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 12.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Spacer(),
                    ExerciseCompletionRing(
                      exercise: exercise,
                      onPressed: onToggleCompletion,
                    ),
                    SizedBox(width: 2.w),
                    actions,
                  ],
                ),
                const Spacer(),
                ExerciseCategoryBadge(label: category),
                SizedBox(height: 10.h),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColorPalette.textOnDark,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    height: 1.05,
                    shadows: const <Shadow>[
                      Shadow(
                        color: Color(0x660A1E4A),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  metaLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColorPalette.textOnDark.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12.h),
                if (isDuration)
                  ExerciseCardLiveTimer(
                    completedSets: exercise.completedSets,
                    totalSets: exercise.sets,
                    activeTimer: activeTimer,
                  )
                else
                  ExerciseSetProgress(
                    completedSets: exercise.completedSets,
                    totalSets: exercise.sets,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
