import 'dart:async';

import '../../data/models/active_exercise_timer.dart';

/// Owns duration-exercise countdowns and a shared tick loop.
///
/// Updates are pushed through [onChanged] so [WorkoutCubit] can emit without
/// persisting (timers are session-only). When a countdown hits zero,
/// [onSetCompleted] fires so the cubit can persist the finished set.
class ExerciseTimerEngine {
  ExerciseTimerEngine({
    required this.onChanged,
    this.onSetCompleted,
    this.tickInterval = const Duration(milliseconds: 100),
  });

  final void Function(Map<String, ActiveExerciseTimer> timers) onChanged;
  final void Function(String exerciseId)? onSetCompleted;
  final Duration tickInterval;

  final Map<String, ActiveExerciseTimer> _timers =
      <String, ActiveExerciseTimer>{};
  Timer? _ticker;

  Map<String, ActiveExerciseTimer> get snapshot =>
      Map<String, ActiveExerciseTimer>.unmodifiable(_timers);

  ActiveExerciseTimer ensure({
    required String exerciseId,
    required int totalSeconds,
  }) {
    final ActiveExerciseTimer? existing = _timers[exerciseId];
    if (existing != null && existing.totalSeconds == totalSeconds) {
      return existing;
    }
    final ActiveExerciseTimer fresh = ActiveExerciseTimer.fresh(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
    );
    _timers[exerciseId] = fresh;
    _publish();
    return fresh;
  }

  void toggle({
    required String exerciseId,
    required int totalSeconds,
  }) {
    final ActiveExerciseTimer current = ensure(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
    );
    if (current.isFinished) {
      return;
    }
    _timers[exerciseId] = current.copyWith(isRunning: !current.isRunning);
    _syncTicker();
    _publish();
  }

  void restart({
    required String exerciseId,
    required int totalSeconds,
  }) {
    _timers[exerciseId] = ActiveExerciseTimer.fresh(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
    ).copyWith(isRunning: true);
    _syncTicker();
    _publish();
  }

  void resetIdle({
    required String exerciseId,
    required int totalSeconds,
  }) {
    _timers[exerciseId] = ActiveExerciseTimer.fresh(
      exerciseId: exerciseId,
      totalSeconds: totalSeconds,
    );
    _syncTicker();
    _publish();
  }

  void clear(String exerciseId) {
    if (_timers.remove(exerciseId) == null) {
      return;
    }
    _syncTicker();
    _publish();
  }

  void retainOnly(Set<String> exerciseIds) {
    final int before = _timers.length;
    _timers.removeWhere((String id, _) => !exerciseIds.contains(id));
    if (_timers.length == before) {
      return;
    }
    _syncTicker();
    _publish();
  }

  /// Stops the tick loop and drops every timer (e.g. on load/reset).
  void reset({bool notify = true}) {
    _ticker?.cancel();
    _ticker = null;
    _timers.clear();
    if (notify) {
      _publish();
    }
  }

  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    _timers.clear();
  }

  void _syncTicker() {
    final bool anyRunning = _timers.values.any(
      (ActiveExerciseTimer timer) => timer.isRunning,
    );
    if (anyRunning) {
      _ticker ??= Timer.periodic(tickInterval, (_) => _onTick());
      return;
    }
    _ticker?.cancel();
    _ticker = null;
  }

  void _onTick() {
    bool changed = false;
    final List<String> completed = <String>[];
    for (final MapEntry<String, ActiveExerciseTimer> entry
        in _timers.entries.toList(growable: false)) {
      final ActiveExerciseTimer timer = entry.value;
      if (!timer.isRunning || timer.isFinished) {
        continue;
      }
      final int nextMs = timer.remainingMs - tickInterval.inMilliseconds;
      if (nextMs <= 0) {
        _timers[entry.key] = timer.copyWith(remainingMs: 0, isRunning: false);
        completed.add(entry.key);
      } else {
        _timers[entry.key] = timer.copyWith(remainingMs: nextMs);
      }
      changed = true;
    }
    if (changed) {
      _syncTicker();
      _publish();
    }
    for (final String exerciseId in completed) {
      onSetCompleted?.call(exerciseId);
    }
  }

  void _publish() => onChanged(snapshot);
}
