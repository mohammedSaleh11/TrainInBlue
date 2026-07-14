import '../../Core/services/local_storage_service.dart';

/// Persists whether onboarding has been completed.
abstract class OnboardingRepository {
  /// True when onboarding was completed before. Missing or corrupt state
  /// safely reports false so onboarding is shown again.
  bool isCompleted();

  Future<void> markCompleted();
}

class LocalOnboardingRepository implements OnboardingRepository {
  LocalOnboardingRepository({required LocalStorageService storage})
    : _storage = storage;

  static const String storageKey = 'onboarding_completed';

  final LocalStorageService _storage;

  @override
  bool isCompleted() {
    try {
      return _storage.readBool(storageKey) ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> markCompleted() async {
    await _storage.writeBool(storageKey, true);
  }
}
