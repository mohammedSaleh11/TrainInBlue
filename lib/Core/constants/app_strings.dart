/// User-facing copy, centralized for consistency and future localization.
class AppStrings {
  AppStrings._();

  static const String appName = 'TrainInBlue';
  static const String splashTagline = 'Build. Train. Resume.';

  // Onboarding.
  static const String onboardingBuildHeadline =
      'Build a workout that fits today.';
  static const String onboardingBuildCopy =
      'Choose your exercises, set your targets, and arrange the session '
      'your way.';
  static const String onboardingProgressHeadline = 'See every step forward.';
  static const String onboardingProgressCopy =
      'Complete exercises as you train and watch your progress update '
      'instantly.';
  static const String onboardingResumeHeadline = 'Your workout stays with you.';
  static const String onboardingResumeCopy =
      'TrainInBlue saves changes on your device, so an unfinished session is '
      'ready when you return.';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String buildMyWorkout = 'Build my workout';

  // Workout home.
  static const String yourWorkout = 'Your workout';
  static const String workoutSubtitle = 'One session, arranged your way';
  static const String addExercise = 'Add exercise';
  static const String resetWorkout = 'Reset workout';
  static const String progressTitle = 'Session progress';
  static const String allDoneTitle = 'Workout complete!';
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';
  static const String exercisesSectionTitle = 'Today\'s exercises';
  static const String motivationNotStarted =
      'Ready when you are — first one sets the tone.';
  static const String motivationInProgress = 'Great pace. Keep it rolling!';
  static const String motivationAlmostDone = 'One to go — strong finish!';
  static const String motivationComplete = 'Everything done. Amazing work!';
  static const String emptyTitle = 'No exercises yet';
  static const String emptyMessage =
      'Your workout is empty. Add your first exercise to start building '
      'today\'s session.';

  // Load failures.
  static const String tryAgain = 'Try again';
  static const String startEmpty = 'Start empty';
  static const String starterDataInvalidTitle = 'Starter workout unavailable';
  static const String starterDataInvalidMessage =
      'The bundled starter exercises could not be read. You can try again or '
      'begin with an empty workout.';
  static const String savedDataCorruptTitle = 'Saved workout can\'t be opened';
  static const String savedDataCorruptMessage =
      'Your saved workout appears to be damaged, so it was left untouched. '
      'You can try again or begin with an empty workout.';
  static const String storageReadFailedTitle = 'Couldn\'t load your workout';
  static const String storageReadFailedMessage =
      'Something went wrong while reading your saved workout. You can try '
      'again or begin with an empty workout.';

  // Save failures.
  static const String saveFailedMessage =
      'Your latest change may not be saved on this device.';
  static const String retry = 'Retry';

  // Exercise form.
  static const String addExerciseTitle = 'Add exercise';
  static const String editExerciseTitle = 'Edit exercise';
  static const String nameLabel = 'Exercise name';
  static const String nameHint = 'e.g. Goblet Squat';
  static const String categoryLabel = 'Category';
  static const String categoryHint = 'e.g. Legs';
  static const String targetTypeLabel = 'Target';
  static const String repetitionsLabel = 'Repetitions per set';
  static const String durationLabel = 'Duration per set (seconds)';
  static const String setsLabel = 'Sets';
  static const String saveExercise = 'Save exercise';

  // Dialogs.
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String reset = 'Reset';
  static const String keepTraining = 'Keep training';
  static const String celebrationTitle = 'Workout complete!';

  static String deleteExerciseTitle(String name) => 'Delete "$name"?';
  static const String deleteExerciseMessage =
      'This removes the exercise from your workout. This can\'t be undone.';

  static const String resetWorkoutTitle = 'Reset workout?';
  static String resetWorkoutMessage({required int completedCount}) {
    final String progressPart = completedCount > 0
        ? 'your progress on $completedCount completed '
              '${completedCount == 1 ? 'exercise' : 'exercises'} and '
        : '';
    return 'This restores the starter workout. You\'ll lose '
        '${progressPart}any changes you\'ve made to your exercise list.';
  }

  static String celebrationMessage(int total) =>
      'You finished all $total exercises in this session. Outstanding work — '
      'see you at the next one!';

  // Exercise card.
  static const String completedLabel = 'Completed';
  static const String markComplete = 'Mark complete';
  static const String reopenExercise = 'Reopen exercise';
  static const String edit = 'Edit';
  static const String reorderHint = 'Drag to reorder';

  // Exercise detail.
  static const String howToPerform = 'How to perform';
  static const String coachTips = 'Coach tips';
  static const String equipmentTitle = 'Equipment';
  static const String bodyweightOnly = 'Bodyweight only — nothing needed';
  static const String setTrackerTitle = 'Set tracker';
  static const String setTrackerHint = 'Tap a set as you finish it.';
  static const String allSetsTracked = 'All sets done — mark it complete!';
  static const String setTimerTitle = 'Set timer';
  static const String timerStart = 'Start';
  static const String timerPause = 'Pause';
  static const String timerResume = 'Resume';
  static const String timerRestart = 'Restart';
  static const String timerDone = 'Time! Set complete.';

  static String setsTrackedLabel(int done, int total) => '$done of $total sets';
  static String perSetLabel(String target) => '$target per set';
}
