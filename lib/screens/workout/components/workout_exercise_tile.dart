import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../components/cards/exercise_card.dart';
import '../../../data/models/active_exercise_timer.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/staggered_entrance.dart';

/// One reorderable row. Subscribes only to its own [Exercise] (and timer) so
/// siblings do not rebuild when another card's completion or set count changes.
class WorkoutExerciseTile extends StatelessWidget {
  const WorkoutExerciseTile({
    super.key,
    required this.exerciseId,
    required this.reorderIndex,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  });

  final String exerciseId;
  final int reorderIndex;
  final ValueChanged<Exercise> onOpen;
  final ValueChanged<Exercise> onEdit;
  final ValueChanged<Exercise> onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 20.h),
      child: StaggeredEntrance(
        remountKey: exerciseId,
        delay: StaggeredEntrance.delayForIndex(reorderIndex + 1),
        child: BlocSelector<WorkoutCubit, WorkoutState, _TileView?>(
          selector: (WorkoutState state) {
            final Exercise? exercise = state.exerciseById(exerciseId);
            if (exercise == null) {
              return null;
            }
            return _TileView(
              exercise: exercise,
              timer: state.timerFor(exerciseId),
            );
          },
          builder: (BuildContext context, _TileView? view) {
            if (view == null) {
              return const SizedBox.shrink();
            }
            final WorkoutCubit cubit = context.read<WorkoutCubit>();
            return RepaintBoundary(
              child: ExerciseCard(
                exercise: view.exercise,
                reorderIndex: reorderIndex,
                activeTimer: view.timer,
                onToggleCompletion: () =>
                    cubit.toggleCompletion(view.exercise.id),
                onOpen: () => onOpen(view.exercise),
                onEdit: () => onEdit(view.exercise),
                onDelete: () => onDelete(view.exercise),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TileView {
  const _TileView({required this.exercise, required this.timer});

  final Exercise exercise;
  final ActiveExerciseTimer? timer;

  @override
  bool operator ==(Object other) {
    return other is _TileView &&
        other.exercise == exercise &&
        other.timer == timer;
  }

  @override
  int get hashCode => Object.hash(exercise, timer);
}
