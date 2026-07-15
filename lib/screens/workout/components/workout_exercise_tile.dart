import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../components/cards/exercise_card.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/staggered_entrance.dart';

/// One reorderable row. Subscribes only to its own [Exercise] so siblings
/// do not rebuild when another card's completion or set count changes.
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
        child: BlocSelector<WorkoutCubit, WorkoutState, Exercise?>(
          selector: (WorkoutState state) => state.exerciseById(exerciseId),
          builder: (BuildContext context, Exercise? exercise) {
            if (exercise == null) {
              return const SizedBox.shrink();
            }
            final WorkoutCubit cubit = context.read<WorkoutCubit>();
            return RepaintBoundary(
              child: ExerciseCard(
                exercise: exercise,
                reorderIndex: reorderIndex,
                onToggleCompletion: () => cubit.toggleCompletion(exercise.id),
                onOpen: () => onOpen(exercise),
                onEdit: () => onEdit(exercise),
                onDelete: () => onDelete(exercise),
              ),
            );
          },
        ),
      ),
    );
  }
}
