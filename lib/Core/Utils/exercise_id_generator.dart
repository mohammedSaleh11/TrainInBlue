/// Generates unique, stable exercise IDs.
///
/// Injected into the workout cubit so tests can substitute a deterministic
/// sequence.
class ExerciseIdGenerator {
  int _sequence = 0;

  String nextId() {
    _sequence += 1;
    return 'exercise-${DateTime.now().microsecondsSinceEpoch}-$_sequence';
  }
}
