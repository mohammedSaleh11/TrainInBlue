import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Core/Utils/duration_formatter.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/exercise_target_type.dart';

/// Three at-a-glance stats in elevated tiles with gradient icon wells.
class ExerciseStatStrip extends StatelessWidget {
  const ExerciseStatStrip({super.key, required this.exercise});

  final Exercise exercise;

  bool get _isReps => exercise.targetType == ExerciseTargetType.repetitions;

  String get _targetValue => _isReps
      ? '${exercise.repetitions}'
      : DurationFormatter.formatSeconds(exercise.durationSeconds ?? 0);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.primaryBlue.withValues(alpha: 0.14),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Material(
        color: AppColorPalette.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.r),
          side: const BorderSide(color: AppColorPalette.outlineSoft),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 8.w,
            vertical: 14.h,
          ),
          child: Row(
            children: <Widget>[
              _StatTile(
                icon: Icons.repeat_rounded,
                value: '${exercise.sets}',
                label: exercise.sets == 1 ? 'Set' : 'Sets',
              ),
              _TileDivider(),
              _StatTile(
                icon: _isReps
                    ? Icons.fitness_center_rounded
                    : Icons.timer_outlined,
                value: _targetValue,
                label: _isReps ? 'Reps / set' : 'Per set',
              ),
              _TileDivider(),
              _StatTile(
                icon: Icons.track_changes_rounded,
                value: exercise.category,
                label: 'Focus',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            width: 38.r,
            height: 38.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColorPalette.surfaceTintBlue,
                  AppColorPalette.primaryBlue.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.r, color: AppColorPalette.primaryBlue),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              color: AppColorPalette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 52.h,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
      color: AppColorPalette.outlineSoft,
    );
  }
}
