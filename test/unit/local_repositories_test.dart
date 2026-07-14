import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:train_in_blue/Core/errors/app_exceptions.dart';
import 'package:train_in_blue/Core/services/local_storage_service.dart';
import 'package:train_in_blue/data/models/exercise.dart';
import 'package:train_in_blue/data/repositories/onboarding_repository.dart';
import 'package:train_in_blue/data/repositories/workout_repository.dart';

import '../helpers/fake_repositories.dart';

/// Serves an in-memory string as the starter-exercises asset.
class FakeAssetBundle extends CachingAssetBundle {
  FakeAssetBundle(this._payload);

  final String? _payload;

  @override
  Future<ByteData> load(String key) async {
    final String? payload = _payload;
    if (payload == null) {
      throw FlutterError('Asset not found: $key');
    }
    return ByteData.sublistView(utf8.encode(payload));
  }
}

const String _validStarterJson = '''
{
  "exercises": [
    {"id": "s1", "name": "Squat", "category": "Legs",
     "targetType": "repetitions", "sets": 3, "repetitions": 12,
     "isCompleted": false, "order": 0},
    {"id": "s2", "name": "Plank", "category": "Core",
     "targetType": "duration", "sets": 3, "durationSeconds": 45,
     "isCompleted": false, "order": 1}
  ]
}
''';

Future<LocalWorkoutRepository> buildRepository({
  Map<String, Object> initialValues = const <String, Object>{},
  String? starterJson = _validStarterJson,
}) async {
  SharedPreferences.setMockInitialValues(initialValues);
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  return LocalWorkoutRepository(
    storage: LocalStorageService(preferences),
    assetBundle: FakeAssetBundle(starterJson),
    clock: () => DateTime(2026, 7, 14),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalWorkoutRepository', () {
    test('first launch copies starter data into storage', () async {
      final LocalWorkoutRepository repository = await buildRepository();

      final List<Exercise> exercises = await repository.loadWorkout();

      expect(exercises, hasLength(2));
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      expect(
        preferences.getString(LocalWorkoutRepository.storageKey),
        isNotNull,
      );
    });

    test('saved workout round-trips exactly after save', () async {
      final LocalWorkoutRepository repository = await buildRepository();
      final List<Exercise> mutated = <Exercise>[
        buildExercise(id: 'custom-1', order: 0, isCompleted: true),
        buildExercise(id: 'custom-2', order: 1),
      ];

      await repository.saveWorkout(mutated);
      final List<Exercise> restored = await repository.loadWorkout();

      expect(restored, mutated);
    });

    test('corrupt saved data throws and is left untouched', () async {
      final LocalWorkoutRepository repository = await buildRepository(
        initialValues: <String, Object>{
          LocalWorkoutRepository.storageKey: '{not valid json',
        },
      );

      await expectLater(
        repository.loadWorkout(),
        throwsA(isA<CorruptSavedWorkoutException>()),
      );
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      expect(
        preferences.getString(LocalWorkoutRepository.storageKey),
        '{not valid json',
      );
    });

    test('invalid or empty starter data throws StarterDataException', () async {
      final LocalWorkoutRepository invalid = await buildRepository(
        starterJson: '{"exercises": "oops"}',
      );
      await expectLater(
        invalid.loadWorkout(),
        throwsA(isA<StarterDataException>()),
      );

      final LocalWorkoutRepository empty = await buildRepository(
        starterJson: '{"exercises": []}',
      );
      await expectLater(
        empty.loadWorkout(),
        throwsA(isA<StarterDataException>()),
      );

      final LocalWorkoutRepository missing = await buildRepository(
        starterJson: null,
      );
      await expectLater(
        missing.loadWorkout(),
        throwsA(isA<StarterDataException>()),
      );
    });
  });

  group('LocalOnboardingRepository', () {
    test('missing or corrupt flag safely reports not completed', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final LocalOnboardingRepository repository = LocalOnboardingRepository(
        storage: LocalStorageService(preferences),
      );

      expect(repository.isCompleted(), isFalse);

      SharedPreferences.setMockInitialValues(<String, Object>{
        LocalOnboardingRepository.storageKey: 'not-a-bool',
      });
      final SharedPreferences corrupted = await SharedPreferences.getInstance();
      final LocalOnboardingRepository corruptedRepository =
          LocalOnboardingRepository(storage: LocalStorageService(corrupted));

      expect(corruptedRepository.isCompleted(), isFalse);
    });

    test('markCompleted persists the flag', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      final LocalOnboardingRepository repository = LocalOnboardingRepository(
        storage: LocalStorageService(preferences),
      );

      await repository.markCompleted();

      expect(repository.isCompleted(), isTrue);
    });
  });
}
