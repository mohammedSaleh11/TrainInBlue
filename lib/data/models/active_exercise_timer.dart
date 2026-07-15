import 'package:equatable/equatable.dart';

/// In-session countdown for one duration exercise set.
///
/// Lives in [WorkoutState] (not persisted) so the timer survives leaving the
/// detail screen and can drive the home card while still running.
class ActiveExerciseTimer extends Equatable {
  const ActiveExerciseTimer({
    required this.exerciseId,
    required this.totalSeconds,
    required this.remainingMs,
    required this.isRunning,
  });

  factory ActiveExerciseTimer.fresh({
    required String exerciseId,
    required int totalSeconds,
  }) {
    return ActiveExerciseTimer(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
      remainingMs: totalSeconds * 1000,
      isRunning: false,
    );
  }

  final String exerciseId;
  final int totalSeconds;
  final int remainingMs;
  final bool isRunning;

  bool get isFinished => remainingMs <= 0;
  bool get hasStarted => remainingMs < totalSeconds * 1000;

  double get consumed {
    final int totalMs = totalSeconds * 1000;
    if (totalMs <= 0) {
      return 1;
    }
    return (1 - (remainingMs / totalMs)).clamp(0, 1);
  }

  int get remainingSeconds {
    if (remainingMs <= 0) {
      return 0;
    }
    return (remainingMs / 1000).ceil();
  }

  String get clockLabel {
    final int seconds = remainingSeconds;
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  ActiveExerciseTimer copyWith({
    int? remainingMs,
    bool? isRunning,
  }) {
    return ActiveExerciseTimer(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
      remainingMs: (remainingMs ?? this.remainingMs).clamp(0, totalSeconds * 1000),
      isRunning: isRunning ?? this.isRunning,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    exerciseId,
    totalSeconds,
    remainingMs,
    isRunning,
  ];
}
