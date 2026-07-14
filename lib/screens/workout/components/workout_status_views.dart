import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../Core/constants/app_assets.dart';
import '../../../Core/constants/app_strings.dart';
import '../../../components/buttons/primary_action_button.dart';
import '../../../widgets/status_view.dart';

/// Branded loading indicator shown while the saved workout is restored,
/// so saved data never flashes behind starter content.
class WorkoutLoadingView extends StatelessWidget {
  const WorkoutLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 44.w,
            height: 44.w,
            child: const CircularProgressIndicator(strokeWidth: 4),
          ),
          SizedBox(height: 18.h),
          Text(
            'Loading your workout…',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

/// Empty session: explains the state and offers the primary recovery action.
class WorkoutEmptyView extends StatelessWidget {
  const WorkoutEmptyView({super.key, required this.onAddExercise});

  final VoidCallback onAddExercise;

  @override
  Widget build(BuildContext context) {
    return StatusView(
      imageAsset: AppAssets.emptyWorkout,
      title: AppStrings.emptyTitle,
      message: AppStrings.emptyMessage,
      actions: <Widget>[
        PrimaryActionButton(
          label: AppStrings.addExercise,
          icon: Icons.add,
          onPressed: onAddExercise,
        ),
      ],
    );
  }
}

/// Load failure with clear recovery paths: retry, or explicitly start empty.
/// Corrupted saved data is never overwritten without this explicit choice.
class WorkoutFailureView extends StatelessWidget {
  const WorkoutFailureView({super.key, required this.reason});

  final WorkoutFailureReason reason;

  @override
  Widget build(BuildContext context) {
    final (String title, String message) = switch (reason) {
      WorkoutFailureReason.corruptSavedWorkout => (
        AppStrings.savedDataCorruptTitle,
        AppStrings.savedDataCorruptMessage,
      ),
      WorkoutFailureReason.starterDataInvalid => (
        AppStrings.starterDataInvalidTitle,
        AppStrings.starterDataInvalidMessage,
      ),
      WorkoutFailureReason.storageFailure => (
        AppStrings.storageReadFailedTitle,
        AppStrings.storageReadFailedMessage,
      ),
    };
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    return StatusView(
      icon: Icons.cloud_off_rounded,
      title: title,
      message: message,
      actions: <Widget>[
        PrimaryActionButton(
          label: AppStrings.tryAgain,
          icon: Icons.refresh,
          onPressed: cubit.loadWorkout,
        ),
        OutlinedButton(
          onPressed: cubit.startEmpty,
          child: const Text(AppStrings.startEmpty),
        ),
      ],
    );
  }
}
