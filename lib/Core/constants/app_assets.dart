/// Central registry of bundled asset paths.
class AppAssets {
  AppAssets._();

  static const String starterExercisesJson = 'assets/data/exercises.json';

  static const String appIcon = 'assets/branding/app_icon.png';

  static const String onboardingBuild =
      'assets/images/onboarding/onboarding_build.png';
  static const String onboardingProgress =
      'assets/images/onboarding/onboarding_progress.png';
  static const String onboardingResume =
      'assets/images/onboarding/onboarding_resume.png';

  static const String workoutHero = 'assets/images/workout_hero.png';
  static const String emptyWorkout = 'assets/images/empty_workout.png';
  static const String celebration = 'assets/images/celebration.png';
  static const String exerciseFormHero = 'assets/images/exercise_form_hero.png';

  static const String _categoryFolder = 'assets/images/categories';

  static const Map<String, String> _categoryThumbnails = <String, String>{
    'legs': '$_categoryFolder/category_legs.png',
    'chest': '$_categoryFolder/category_chest.png',
    'back': '$_categoryFolder/category_back.png',
    'core': '$_categoryFolder/category_core.png',
    'cardio': '$_categoryFolder/category_cardio.png',
  };

  static const String genericCategoryThumbnail =
      '$_categoryFolder/category_general.png';

  /// Thumbnail for an exercise category; unknown categories get the
  /// generic equipment still-life so user-created categories never break.
  static String categoryThumbnail(String category) {
    return _categoryThumbnails[category.trim().toLowerCase()] ??
        genericCategoryThumbnail;
  }

  static const String _exerciseFolder = 'assets/images/exercises';

  static const Map<String, String> _exerciseImages = <String, String>{
    'squat': '$_exerciseFolder/squat.png',
    'push-up': '$_exerciseFolder/push_up.png',
    'push up': '$_exerciseFolder/push_up.png',
    'pushup': '$_exerciseFolder/push_up.png',
    'bent-over row': '$_exerciseFolder/bent_over_row.png',
    'bent over row': '$_exerciseFolder/bent_over_row.png',
    'reverse lunge': '$_exerciseFolder/reverse_lunge.png',
    'lunge': '$_exerciseFolder/reverse_lunge.png',
    'plank': '$_exerciseFolder/plank.png',
    'jumping jacks': '$_exerciseFolder/jumping_jacks.png',
  };

  /// Photo for a specific exercise. Known exercise names get their own
  /// image; anything else falls back to the category thumbnail so custom
  /// exercises always render something on-brand.
  static String exerciseImage(String name, String category) {
    return _exerciseImages[name.trim().toLowerCase()] ??
        categoryThumbnail(category);
  }
}
