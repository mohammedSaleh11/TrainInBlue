import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Blocs/workout/workout_cubit.dart';
import '../../Blocs/workout/workout_state.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../Core/constants/exercise_guides.dart';
import '../../Core/services/navigation_service.dart';
import '../../components/dialogs/confirm_dialog.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_target_type.dart';
import '../../widgets/staggered_entrance.dart';
import '../exercise_form/exercise_form_screen.dart';
import 'components/detail_complete_bar.dart';
import 'components/detail_hero.dart';
import 'components/duration_timer_card.dart';
import 'components/exercise_stat_strip.dart';
import 'components/guide_sections.dart';
import 'components/set_tracker_card.dart';

/// The full experience for a single exercise: hero photo, overlapping stats,
/// interactive training tools, coaching panels, and a pinned complete action.
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  Exercise? _cached;

  void _openEdit(Exercise exercise) {
    NavigationService.push(
      ExerciseFormScreen(exerciseToEdit: exercise),
      context: context,
    );
  }

  Future<void> _confirmDelete(Exercise exercise) async {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    final bool confirmed = await showConfirmDialog(
      context,
      title: AppStrings.deleteExerciseTitle(exercise.name),
      message: AppStrings.deleteExerciseMessage,
      confirmLabel: AppStrings.delete,
    );
    if (!confirmed || !mounted) {
      return;
    }
    NavigationService.pop(null, context);
    await cubit.deleteExercise(exercise.id);
  }

  Widget _interactiveCard(Exercise exercise) {
    if (exercise.targetType == ExerciseTargetType.repetitions) {
      return SetTrackerCard(
        key: ValueKey<String>(
          'tracker-${exercise.id}-${exercise.sets}-${exercise.completedSets}',
        ),
        exerciseId: exercise.id,
        sets: exercise.sets,
        completedSets: exercise.completedSets,
      );
    }
    return DurationTimerCard(
      key: ValueKey<String>('timer-${exercise.id}-${exercise.durationSeconds}'),
      durationSeconds: exercise.durationSeconds ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (BuildContext context, WorkoutState state) {
        final Exercise? current = state.exerciseById(widget.exerciseId);
        if (current != null) {
          _cached = current;
        }
        final Exercise? exercise = current ?? _cached;
        if (exercise == null) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return Scaffold(
          backgroundColor: AppColorPalette.iceBackground,
          bottomNavigationBar: DetailCompleteBar(exercise: exercise),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: ExerciseDetailHero(
                  exercise: exercise,
                  onEdit: () => _openEdit(exercise),
                  onDelete: () => _confirmDelete(exercise),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: Offset(0, -32.h),
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                    child: StaggeredEntrance(
                      child: ExerciseStatStrip(exercise: exercise),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 20.w, 0),
                sliver: SliverToBoxAdapter(
                  child: StaggeredEntrance(
                    delay: StaggeredEntrance.delayForIndex(1),
                    child: _interactiveCard(exercise),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 28.h),
                sliver: SliverToBoxAdapter(
                  child: ExerciseGuideSections(
                    guide: ExerciseGuideLibrary.guideFor(
                      exercise.name,
                      exercise.category,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
