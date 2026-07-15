import 'package:flutter/foundation.dart';

/// Stable widget keys used by widget tests and tooling.
class AppKeys {
  AppKeys._();

  // Onboarding.
  static const Key onboardingNext = Key('onboarding_next');
  static const Key onboardingBack = Key('onboarding_back');
  static const Key onboardingSkip = Key('onboarding_skip');
  static const Key onboardingFinish = Key('onboarding_finish');

  // Workout home.
  static const Key addExerciseButton = Key('add_exercise_button');
  static const Key workoutMenuButton = Key('workout_menu_button');
  static const Key resetWorkoutMenuItem = Key('reset_workout_menu_item');
  static const Key progressCard = Key('progress_card');
  static const Key exerciseList = Key('exercise_list');

  static Key exerciseCard(String id) => Key('exercise_card_$id');
  static Key completeToggle(String id) => Key('complete_toggle_$id');
  static Key exerciseMenu(String id) => Key('exercise_menu_$id');
  static Key dragHandle(String id) => Key('drag_handle_$id');

  // Exercise form.
  static const Key nameField = Key('exercise_name_field');
  static const Key categoryField = Key('exercise_category_field');
  static const Key setsField = Key('exercise_sets_field');
  static const Key repetitionsField = Key('exercise_repetitions_field');
  static const Key durationField = Key('exercise_duration_field');
  static const Key targetTypeSelector = Key('exercise_target_type_selector');
  static const Key saveExerciseButton = Key('save_exercise_button');

  // Dialogs.
  static const Key confirmDialogConfirm = Key('confirm_dialog_confirm');
  static const Key confirmDialogCancel = Key('confirm_dialog_cancel');

  // Exercise detail.
  static const Key detailBackButton = Key('detail_back_button');
  static const Key detailMenuButton = Key('detail_menu_button');
  static const Key detailEditMenuItem = Key('detail_edit_menu_item');
  static const Key detailDeleteMenuItem = Key('detail_delete_menu_item');
  static const Key detailCompleteButton = Key('detail_complete_button');
  static const Key timerToggleButton = Key('timer_toggle_button');
  static const Key timerRestartButton = Key('timer_restart_button');
  static const Key timerNextSetButton = Key('timer_next_set_button');

  static Key setDot(int index) => Key('set_dot_$index');
}
