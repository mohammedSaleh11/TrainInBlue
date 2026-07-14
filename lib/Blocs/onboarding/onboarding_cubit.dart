import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/onboarding_repository.dart';

/// Whether the user still needs to see onboarding.
enum OnboardingStatus { unknown, required, completed }

/// Owns the onboarding completion flag; screens never read storage directly.
class OnboardingCubit extends Cubit<OnboardingStatus> {
  OnboardingCubit({required OnboardingRepository repository})
    : _repository = repository,
      super(OnboardingStatus.unknown);

  final OnboardingRepository _repository;

  /// Reads the persisted flag. Missing or corrupt state safely shows
  /// onboarding again.
  void checkCompletion() {
    emit(
      _repository.isCompleted()
          ? OnboardingStatus.completed
          : OnboardingStatus.required,
    );
  }

  /// Stores completion. If the write fails the user still proceeds; the only
  /// consequence is seeing onboarding again on the next launch.
  Future<void> completeOnboarding() async {
    try {
      await _repository.markCompleted();
    } catch (_) {
      // Intentionally swallowed: proceeding to the workout matters more than
      // the flag, and the failure self-heals by re-showing onboarding.
    }
    emit(OnboardingStatus.completed);
  }
}
