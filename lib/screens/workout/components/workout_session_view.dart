import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/colors.dart';
import '../../../components/cards/exercise_card.dart';
import '../../../components/progress/workout_progress_card.dart';
import '../../../data/models/exercise.dart';
import '../../../widgets/staggered_entrance.dart';
import 'workout_hero_header.dart';
import 'workout_section_header.dart';
import 'workout_status_views.dart';

/// Scrollable body of a live session: hero header, progress card, and the
/// reorderable exercise list (or the empty view when there are no exercises).
class WorkoutSessionView extends StatelessWidget {
  const WorkoutSessionView({
    super.key,
    required this.state,
    required this.onResetWorkout,
    required this.onAddExercise,
    required this.onOpenExercise,
    required this.onEditExercise,
    required this.onDeleteExercise,
  });

  final WorkoutState state;
  final VoidCallback onResetWorkout;
  final VoidCallback onAddExercise;
  final ValueChanged<Exercise> onOpenExercise;
  final ValueChanged<Exercise> onEditExercise;
  final ValueChanged<Exercise> onDeleteExercise;

  @override
  Widget build(BuildContext context) {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    return CustomScrollView(
      key: AppKeys.exerciseList,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: WorkoutHeroHeader(onResetWorkout: onResetWorkout),
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 0),
          sliver: SliverToBoxAdapter(
            child: StaggeredEntrance(
              child: WorkoutProgressCard(progress: state.progress),
            ),
          ),
        ),
        if (state.status == WorkoutStatus.empty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: WorkoutEmptyView(onAddExercise: onAddExercise),
          )
        else ...<Widget>[
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 22.h, 20.w, 12.h),
            sliver: SliverToBoxAdapter(
              child: StaggeredEntrance(
                delay: StaggeredEntrance.delayForIndex(1),
                child: WorkoutSectionHeader(count: state.exercises.length),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 110.h),
            sliver: SliverReorderableList(
              itemCount: state.exercises.length,
              onReorder: cubit.reorderExercise,
              proxyDecorator: _decorateDraggedItem,
              itemBuilder: (BuildContext context, int index) {
                final Exercise exercise = state.exercises[index];
                return Padding(
                  key: AppKeys.exerciseCard(exercise.id),
                  padding: EdgeInsetsDirectional.only(bottom: 12.h),
                  child: StaggeredEntrance(
                    delay: StaggeredEntrance.delayForIndex(index + 2),
                    child: ExerciseCard(
                      exercise: exercise,
                      reorderIndex: index,
                      onToggleCompletion: () =>
                          cubit.toggleCompletion(exercise.id),
                      onOpen: () => onOpenExercise(exercise),
                      onEdit: () => onEditExercise(exercise),
                      onDelete: () => onDeleteExercise(exercise),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _decorateDraggedItem(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return ScaleTransition(
      scale: animation.drive(Tween<double>(begin: 1, end: 1.02)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColorPalette.primaryBlue.withValues(alpha: 0.22),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}
