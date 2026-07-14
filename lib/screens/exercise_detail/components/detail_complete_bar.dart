import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';
import '../../../data/models/exercise.dart';

/// Frosted bottom bar with a gradient primary action or an outlined reopen
/// button when the exercise is already complete.
class DetailCompleteBar extends StatelessWidget {
  const DetailCompleteBar({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorPalette.surfaceWhite,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColorPalette.deepNavy.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
        child: SizedBox(
          height: 54.h,
          width: double.infinity,
          child: exercise.isCompleted
              ? OutlinedButton.icon(
                  key: AppKeys.detailCompleteButton,
                  onPressed: () => cubit.toggleCompletion(exercise.id),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text(AppStrings.reopenExercise),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: <Color>[
                        AppColorPalette.primaryBlue,
                        AppColorPalette.primaryBlueDark,
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColorPalette.primaryBlue.withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 12.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: FilledButton.icon(
                    key: AppKeys.detailCompleteButton,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: () => cubit.toggleCompletion(exercise.id),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text(AppStrings.markComplete),
                  ),
                ),
        ),
      ),
    );
  }
}
