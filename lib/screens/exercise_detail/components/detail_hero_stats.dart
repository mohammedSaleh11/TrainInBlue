import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/duration_formatter.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/exercise_target_type.dart';

/// Frosted stat bar on the hero image — sets, target, and focus at a glance.
/// Translucent fill only (no [BackdropFilter]) so route fade transitions work
/// under Impeller.
class DetailHeroStats extends StatelessWidget {
  const DetailHeroStats({super.key, required this.exercise});

  final Exercise exercise;

  bool get _isReps => exercise.targetType == ExerciseTargetType.repetitions;

  String get _targetValue => _isReps
      ? '${exercise.repetitions}'
      : DurationFormatter.formatSeconds(exercise.durationSeconds ?? 0);

  String get _targetLabel => _isReps ? 'Reps / set' : 'Per set';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 4.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: AppColorPalette.frostedOnImage,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: AppColorPalette.textOnDark.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: <Widget>[
          _HeroStat(
            value: '${exercise.sets}',
            label: exercise.sets == 1 ? 'Set' : 'Sets',
          ),
          _HeroStatDivider(),
          _HeroStat(value: _targetValue, label: _targetLabel),
          _HeroStatDivider(),
          _HeroStat(value: exercise.category, label: 'Focus'),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: AppColorPalette.textOnDark,
              height: 1.1,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColorPalette.textOnDark.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30.h,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 2.w),
      color: AppColorPalette.textOnDark.withValues(alpha: 0.18),
    );
  }
}
