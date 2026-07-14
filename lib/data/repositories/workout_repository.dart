import 'dart:convert';

import 'package:flutter/services.dart';

import '../../Core/constants/app_assets.dart';
import '../../Core/errors/app_exceptions.dart';
import '../../Core/services/local_storage_service.dart';
import '../models/exercise.dart';
import '../models/workout_snapshot.dart';

/// Contract for loading and persisting the single active workout. The cubit
/// depends on this abstraction; tests substitute an in-memory fake.
abstract class WorkoutRepository {
  /// Loads the saved exercises, seeding them from the bundled starter data on
  /// first launch only. After initialization, saved data is the sole source
  /// of truth.
  Future<List<Exercise>> loadWorkout();

  /// Persists the whole workout atomically as one versioned document.
  Future<void> saveWorkout(List<Exercise> exercises);

  /// Parses a fresh copy of the bundled starter exercises (all incomplete).
  Future<List<Exercise>> loadStarterExercises();
}

/// [WorkoutRepository] backed by local key-value storage and bundled JSON.
class LocalWorkoutRepository implements WorkoutRepository {
  LocalWorkoutRepository({
    required LocalStorageService storage,
    AssetBundle? assetBundle,
    DateTime Function()? clock,
  }) : _storage = storage,
       _assetBundle = assetBundle ?? rootBundle,
       _clock = clock ?? DateTime.now;

  static const String storageKey = 'workout_snapshot';

  final LocalStorageService _storage;
  final AssetBundle _assetBundle;
  final DateTime Function() _clock;

  @override
  Future<List<Exercise>> loadWorkout() async {
    final String? savedPayload = _storage.readString(storageKey);
    if (savedPayload == null) {
      final List<Exercise> starterExercises = await loadStarterExercises();
      await saveWorkout(starterExercises);
      return starterExercises;
    }
    return _parseSavedPayload(savedPayload).exercises;
  }

  @override
  Future<void> saveWorkout(List<Exercise> exercises) async {
    final WorkoutSnapshot snapshot = WorkoutSnapshot(
      schemaVersion: WorkoutSnapshot.currentSchemaVersion,
      updatedAt: _clock(),
      exercises: WorkoutSnapshot.sortedByOrder(exercises),
    );
    await _storage.writeString(storageKey, jsonEncode(snapshot.toJson()));
  }

  @override
  Future<List<Exercise>> loadStarterExercises() async {
    final String rawJson;
    try {
      rawJson = await _assetBundle.loadString(AppAssets.starterExercisesJson);
    } catch (_) {
      throw const StarterDataException();
    }
    try {
      final Object? decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Starter data is not an object.');
      }
      final Object? rawExercises = decoded['exercises'];
      if (rawExercises is! List || rawExercises.isEmpty) {
        throw const FormatException('Starter data has no exercises.');
      }
      return rawExercises
          .map((Object? entry) {
            if (entry is! Map<String, dynamic>) {
              throw const FormatException('Starter entry is not an object.');
            }
            return Exercise.fromJson(entry);
          })
          .toList(growable: false);
    } on FormatException {
      throw const StarterDataException();
    }
  }

  /// Parses saved JSON. A damaged payload throws and is left untouched so the
  /// user chooses how to recover; it is never silently overwritten.
  WorkoutSnapshot _parseSavedPayload(String payload) {
    try {
      final Object? decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Workout payload is not an object.');
      }
      return WorkoutSnapshot.fromJson(decoded);
    } on FormatException {
      throw const CorruptSavedWorkoutException();
    }
  }
}
