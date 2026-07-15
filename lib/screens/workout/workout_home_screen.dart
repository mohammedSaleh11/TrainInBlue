import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/workout/workout_cubit.dart';
import '../../Blocs/workout/workout_state.dart';
import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/services/navigation_service.dart';
import '../../components/dialogs/celebration_dialog.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../data/models/exercise.dart';
import '../exercise_detail/exercise_detail_screen.dart';
import '../exercise_form/exercise_form_screen.dart';
import 'components/workout_session_view.dart';
import 'components/workout_status_views.dart';

/// The single workout session with explicit loading, empty, and failure
/// states. The screen only renders [WorkoutState] and dispatches intent to
/// [WorkoutCubit]; side effects arrive through listeners.
class WorkoutHomeScreen extends StatelessWidget {
  const WorkoutHomeScreen({super.key});

  void _openAddExercise(BuildContext context) {
    NavigationService.push(const ExerciseFormScreen(), context: context);
  }

  void _openEditExercise(BuildContext context, Exercise exercise) {
    NavigationService.push(
      ExerciseFormScreen(exerciseToEdit: exercise),
      context: context,
    );
  }

  void _openExerciseDetail(BuildContext context, Exercise exercise) {
    NavigationService.pushFade(
      ExerciseDetailScreen(exerciseId: exercise.id),
      context: context,
    );
  }

  Future<void> _confirmDelete(BuildContext context, Exercise exercise) async {
    final bool confirmed = await showConfirmDialog(
      context,
      title: AppStrings.deleteExerciseTitle(exercise.name),
      message: AppStrings.deleteExerciseMessage,
      confirmLabel: AppStrings.delete,
    );
    if (confirmed && context.mounted) {
      await context.read<WorkoutCubit>().deleteExercise(exercise.id);
    }
  }

  Future<void> _confirmReset(BuildContext context) async {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    final bool confirmed = await showConfirmDialog(
      context,
      title: AppStrings.resetWorkoutTitle,
      message: AppStrings.resetWorkoutMessage(
        completedCount: cubit.state.progress.completedCount,
      ),
      confirmLabel: AppStrings.reset,
      icon: Icons.restart_alt_rounded,
    );
    if (confirmed) {
      await cubit.resetWorkout();
    }
  }

  void _showSaveFailureSnackBar(BuildContext context) {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(AppStrings.saveFailedMessage),
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: AppStrings.retry,
            onPressed: cubit.retrySave,
          ),
        ),
      );
  }

  void _showCelebration(BuildContext context, WorkoutState state) {
    context.read<WorkoutCubit>().acknowledgeCelebration();
    showCelebrationDialog(context, totalExercises: state.progress.totalCount);
  }

  /// Only swap loading / failure / session shells. Progress and cards
  /// subscribe themselves so a single toggle never rebuilds the scaffold.
  static bool _buildWhen(WorkoutState previous, WorkoutState current) {
    return previous.status != current.status ||
        previous.failureReason != current.failureReason;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<WorkoutCubit, WorkoutState>>[
        BlocListener<WorkoutCubit, WorkoutState>(
          listenWhen: (WorkoutState previous, WorkoutState current) =>
              !previous.hasPendingSaveFailure && current.hasPendingSaveFailure,
          listener: (BuildContext context, _) =>
              _showSaveFailureSnackBar(context),
        ),
        BlocListener<WorkoutCubit, WorkoutState>(
          listenWhen: (WorkoutState previous, WorkoutState current) =>
              !previous.celebrationPending && current.celebrationPending,
          listener: _showCelebration,
        ),
      ],
      child: BlocBuilder<WorkoutCubit, WorkoutState>(
        buildWhen: _buildWhen,
        builder: (BuildContext context, WorkoutState state) {
          return Scaffold(
            floatingActionButton: state.status == WorkoutStatus.ready
                ? FloatingActionButton.extended(
                    key: AppKeys.addExerciseButton,
                    onPressed: () => _openAddExercise(context),
                    icon: const Icon(Icons.add),
                    label: const Text(AppStrings.addExercise),
                  )
                : null,
            body: switch (state.status) {
              WorkoutStatus.loading => const WorkoutLoadingView(),
              WorkoutStatus.failure => WorkoutFailureView(
                reason: state.failureReason!,
              ),
              WorkoutStatus.ready || WorkoutStatus.empty => WorkoutSessionView(
                onResetWorkout: () => _confirmReset(context),
                onAddExercise: () => _openAddExercise(context),
                onOpenExercise: (Exercise exercise) =>
                    _openExerciseDetail(context, exercise),
                onEditExercise: (Exercise exercise) =>
                    _openEditExercise(context, exercise),
                onDeleteExercise: (Exercise exercise) =>
                    _confirmDelete(context, exercise),
              ),
            },
          );
        },
      ),
    );
  }
}
