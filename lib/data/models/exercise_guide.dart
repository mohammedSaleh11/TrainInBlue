import 'package:equatable/equatable.dart';

/// Coaching content shown on the exercise detail screen: how to perform the
/// movement, form tips, and the equipment involved.
class ExerciseGuide extends Equatable {
  const ExerciseGuide({
    required this.summary,
    required this.steps,
    required this.tips,
    required this.equipment,
  });

  /// One-sentence description of what the exercise trains.
  final String summary;

  /// Ordered movement instructions.
  final List<String> steps;

  /// Short form and breathing cues.
  final List<String> tips;

  /// Equipment names; an empty list means bodyweight only.
  final List<String> equipment;

  @override
  List<Object?> get props => <Object?>[summary, steps, tips, equipment];
}
