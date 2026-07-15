import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Blocs/workout/workout_cubit.dart';
import '../../../Blocs/workout/workout_state.dart';
import '../../../data/models/exercise.dart';
import '../../../data/models/exercise_target_type.dart';
import 'duration_timer_card.dart';
import 'set_tracker_card.dart';

/// Set tracker or duration timer. Rebuilds only when tool-relevant fields
/// change (sets / completedSets / duration / target type).
class DetailToolSection extends StatelessWidget {
  const DetailToolSection({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkoutCubit, WorkoutState, _ToolView?>(
      selector: (WorkoutState state) {
        final Exercise? exercise = state.exerciseById(exerciseId);
        if (exercise == null) {
          return null;
        }
        return _ToolView(
          id: exercise.id,
          targetType: exercise.targetType,
          sets: exercise.sets,
          completedSets: exercise.completedSets,
          durationSeconds: exercise.durationSeconds ?? 0,
        );
      },
      builder: (BuildContext context, _ToolView? tool) {
        if (tool == null) {
          return const SizedBox.shrink();
        }
        if (tool.targetType == ExerciseTargetType.repetitions) {
          return SetTrackerCard(
            key: ValueKey<String>('tracker-${tool.id}-${tool.sets}'),
            exerciseId: tool.id,
            sets: tool.sets,
            completedSets: tool.completedSets,
          );
        }
        return DurationTimerCard(
          key: ValueKey<String>(
            'timer-${tool.id}-${tool.durationSeconds}-${tool.sets}',
          ),
          exerciseId: tool.id,
          durationSeconds: tool.durationSeconds,
          sets: tool.sets,
          completedSets: tool.completedSets,
        );
      },
    );
  }
}

class _ToolView {
  const _ToolView({
    required this.id,
    required this.targetType,
    required this.sets,
    required this.completedSets,
    required this.durationSeconds,
  });

  final String id;
  final ExerciseTargetType targetType;
  final int sets;
  final int completedSets;
  final int durationSeconds;

  @override
  bool operator ==(Object other) {
    return other is _ToolView &&
        other.id == id &&
        other.targetType == targetType &&
        other.sets == sets &&
        other.completedSets == completedSets &&
        other.durationSeconds == durationSeconds;
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetType,
    sets,
    completedSets,
    durationSeconds,
  );
}
