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
import '../../widgets/staggered_entrance.dart';
import '../exercise_form/exercise_form_screen.dart';
import 'components/detail_complete_bar.dart';
import 'components/detail_hero.dart';
import 'components/detail_tool_section.dart';
import 'components/guide_sections.dart';

/// Single-exercise experience. The scaffold itself has no bloc subscription;
/// each section selects only the fields it needs so set tracking never
/// rebuilds the guide or hero chrome.
class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  final String exerciseId;

  void _openEdit(BuildContext context, Exercise exercise) {
    NavigationService.push(
      ExerciseFormScreen(exerciseToEdit: exercise),
      context: context,
    );
  }

  Future<void> _confirmDelete(BuildContext context, Exercise exercise) async {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    final bool confirmed = await showConfirmDialog(
      context,
      title: AppStrings.deleteExerciseTitle(exercise.name),
      message: AppStrings.deleteExerciseMessage,
      confirmLabel: AppStrings.delete,
    );
    if (!confirmed || !context.mounted) return;
    NavigationService.pop(null, context);
    await cubit.deleteExercise(exercise.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorPalette.iceBackground,
      bottomNavigationBar: DetailCompleteBar(exerciseId: exerciseId),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: BlocSelector<WorkoutCubit, WorkoutState, Exercise?>(
              selector: (WorkoutState state) => state.exerciseById(exerciseId),
              builder: (BuildContext context, Exercise? exercise) {
                if (exercise == null) {
                  return const SizedBox.shrink();
                }
                return ExerciseDetailHero(
                  exercise: exercise,
                  onEdit: () => _openEdit(context, exercise),
                  onDelete: () => _confirmDelete(context, exercise),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 0),
            sliver: SliverToBoxAdapter(
              child: StaggeredEntrance(
                child: DetailToolSection(exerciseId: exerciseId),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 32.h),
            sliver: SliverToBoxAdapter(
              child: StaggeredEntrance(
                delay: StaggeredEntrance.delayForIndex(1),
                child: BlocSelector<WorkoutCubit, WorkoutState, (String, String)?>(
                  selector: (WorkoutState state) {
                    final Exercise? exercise = state.exerciseById(exerciseId);
                    if (exercise == null) {
                      return null;
                    }
                    return (exercise.name, exercise.category);
                  },
                  builder: (BuildContext context, (String, String)? identity) {
                    if (identity == null) {
                      return const SizedBox.shrink();
                    }
                    return ExerciseGuideSections(
                      guide: ExerciseGuideLibrary.guideFor(
                        identity.$1,
                        identity.$2,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
