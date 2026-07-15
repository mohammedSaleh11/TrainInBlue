import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../Core/constants/colors.dart';

/// Pinned complete / reopen action. Rebuilds only when this exercise's
/// completion flag changes.
class DetailCompleteBar extends StatelessWidget {
  const DetailCompleteBar({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkoutCubit, WorkoutState, bool?>(
      selector: (WorkoutState state) =>
          state.exerciseById(exerciseId)?.isCompleted,
      builder: (BuildContext context, bool? isCompleted) {
        if (isCompleted == null) {
          return const SizedBox.shrink();
        }
        final WorkoutCubit cubit = context.read<WorkoutCubit>();
        return DecoratedBox(
          decoration: BoxDecoration(
            color: AppColorPalette.surfaceWhite,
            border: const Border(
              top: BorderSide(color: AppColorPalette.outlineSoft),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColorPalette.deepNavy.withValues(alpha: 0.08),
                blurRadius: 20.r,
                offset: Offset(0, -6.h),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 16.h),
              child: SizedBox(
                height: 54.h,
                width: double.infinity,
                child: isCompleted
                    ? OutlinedButton.icon(
                        key: AppKeys.detailCompleteButton,
                        onPressed: () => cubit.toggleCompletion(exerciseId),
                        icon: const Icon(Icons.replay_rounded),
                        label: const Text(AppStrings.reopenExercise),
                      )
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
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
                              blurRadius: 16.r,
                              offset: Offset(0, 6.h),
                            ),
                          ],
                        ),
                        child: FilledButton.icon(
                          key: AppKeys.detailCompleteButton,
                          onPressed: () => cubit.toggleCompletion(exerciseId),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          icon: const Icon(Icons.check_rounded),
                          label: const Text(AppStrings.markComplete),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
