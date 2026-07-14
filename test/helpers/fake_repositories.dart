import 'package:train_in_blue/Core/errors/app_exceptions.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/models/exercise_target_type.dart';
import 'package:train_in_blue/data/repositories/onboarding_repository.dart';
import 'package:train_in_blue/data/repositories/workout_repository.dart';

/// Builds a deterministic exercise for tests.
Exercise buildExercise({
  required String id,
  required int order,
  String? name,
  String category = 'Legs',
  ExerciseTargetType targetType = ExerciseTargetType.repetitions,
  int sets = 3,
  int? repetitions = 10,
  int? durationSeconds,
  bool isCompleted = false,
  int completedSets = 0,
}) {
  final bool countsRepetitions = targetType == ExerciseTargetType.repetitions;
  return Exercise(
    id: id,
    name: name ?? 'Exercise $id',
    category: category,
    targetType: targetType,
    sets: sets,
    repetitions: countsRepetitions ? repetitions : null,
    durationSeconds: countsRepetitions ? null : (durationSeconds ?? 30),
    isCompleted: isCompleted,
    order: order,
    completedSets: completedSets,
  );
}

/// In-memory [WorkoutRepository] with failure switches and a save log, so
/// tests never touch real device storage.
class FakeWorkoutRepository implements WorkoutRepository {
  FakeWorkoutRepository({
    List<Exercise>? savedExercises,
    List<Exercise>? starterExercises,
  }) : _saved = savedExercises,
       _starter =
           starterExercises ??
           <Exercise>[
             buildExercise(id: 'starter-1', order: 0),
             buildExercise(id: 'starter-2', order: 1, category: 'Core'),
           ];

  List<Exercise>? _saved;
  final List<Exercise> _starter;

  /// Every successfully saved exercise list, oldest first.
  final List<List<Exercise>> saveLog = <List<Exercise>>[];

  bool failNextSave = false;
  AppException? loadFailure;
  bool starterDataInvalid = false;

  List<Exercise>? get savedExercises => _saved;

  @override
  Future<List<Exercise>> loadWorkout() async {
    final AppException? failure = loadFailure;
    if (failure != null) {
      throw failure;
    }
    final List<Exercise>? saved = _saved;
    if (saved == null) {
      final List<Exercise> starter = await loadStarterExercises();
      await saveWorkout(starter);
      return starter;
    }
    return saved;
  }

  @override
  Future<void> saveWorkout(List<Exercise> exercises) async {
    if (failNextSave) {
      failNextSave = false;
      throw const StorageWriteException();
    }
    _saved = List<Exercise>.of(exercises);
    saveLog.add(List<Exercise>.of(exercises));
  }

  @override
  Future<List<Exercise>> loadStarterExercises() async {
    if (starterDataInvalid) {
      throw const StarterDataException();
    }
    return List<Exercise>.of(_starter);
  }
}

/// In-memory [OnboardingRepository] for widget tests.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({bool completed = false}) : _completed = completed;

  bool _completed;

  @override
  bool isCompleted() => _completed;

  @override
  Future<void> markCompleted() async {
    _completed = true;
  }
}
