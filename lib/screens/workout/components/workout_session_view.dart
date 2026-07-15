import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../Core/constants/app_keys.dart';
import '../../../Core/constants/colors.dart';
import '../../../components/progress/workout_progress_card.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/workout_progress.dart';
import '../../../widgets/staggered_entrance.dart';
import 'workout_exercise_tile.dart';
import 'workout_hero_header.dart';
import 'workout_status_views.dart';

/// Scrollable body of a live session. Each section selects only the slice of
/// [WorkoutState] it needs so progress, hero count, and cards rebuild alone.
class WorkoutSessionView extends StatelessWidget {
  const WorkoutSessionView({
    super.key,
    required this.onResetWorkout,
    required this.onAddExercise,
    required this.onOpenExercise,
    required this.onEditExercise,
    required this.onDeleteExercise,
  });

  final VoidCallback onResetWorkout;
  final VoidCallback onAddExercise;
  final ValueChanged<Exercise> onOpenExercise;
  final ValueChanged<Exercise> onEditExercise;
  final ValueChanged<Exercise> onDeleteExercise;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: AppKeys.exerciseList,
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: BlocSelector<WorkoutCubit, WorkoutState, int>(
            selector: (WorkoutState state) => state.exercises.length,
            builder: (BuildContext context, int exerciseCount) {
              return WorkoutHeroHeader(
                onResetWorkout: onResetWorkout,
                exerciseCount: exerciseCount,
              );
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 0),
          sliver: SliverToBoxAdapter(
            child: StaggeredEntrance(
              child: BlocSelector<WorkoutCubit, WorkoutState, WorkoutProgress>(
                selector: (WorkoutState state) => state.progress,
                builder: (BuildContext context, WorkoutProgress progress) {
                  return RepaintBoundary(
                    child: WorkoutProgressCard(progress: progress),
                  );
                },
              ),
            ),
          ),
        ),
        BlocSelector<WorkoutCubit, WorkoutState, List<String>>(
          selector: (WorkoutState state) => state.exercises
              .map((Exercise exercise) => exercise.id)
              .toList(growable: false),
          builder: (BuildContext context, List<String> exerciseIds) {
            if (exerciseIds.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: WorkoutEmptyView(onAddExercise: onAddExercise),
              );
            }
            final WorkoutCubit cubit = context.read<WorkoutCubit>();
            return SliverPadding(
              padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 110.h),
              sliver: SliverReorderableList(
                itemCount: exerciseIds.length,
                onReorder: cubit.reorderExercise,
                proxyDecorator: _decorateDraggedItem,
                findChildIndexCallback: (Key key) {
                  if (key is! ValueKey<String>) {
                    return null;
                  }
                  final String value = key.value;
                  const String prefix = 'exercise_card_';
                  if (!value.startsWith(prefix)) {
                    return null;
                  }
                  final String id = value.substring(prefix.length);
                  final int index = exerciseIds.indexOf(id);
                  return index >= 0 ? index : null;
                },
                itemBuilder: (BuildContext context, int index) {
                  final String id = exerciseIds[index];
                  return WorkoutExerciseTile(
                    key: AppKeys.exerciseCard(id),
                    exerciseId: id,
                    reorderIndex: index,
                    onOpen: onOpenExercise,
                    onEdit: onEditExercise,
                    onDelete: onDeleteExercise,
                  );
                },
              ),
            );
          },
        ),
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
        child: HeroMode(
          enabled: false,
          child: Material(color: Colors.transparent, child: child),
        ),
      ),
    );
  }
}
