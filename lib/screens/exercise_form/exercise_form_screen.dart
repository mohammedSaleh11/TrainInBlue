import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Blocs/workout/workout_cubit.dart';
import '../../Core/Utils/exercise_draft_validator.dart';
import '../../Core/constants/app_keys.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/services/navigation_service.dart';
import '../../components/Inputs/app_text_field.dart';
import '../../components/buttons/primary_action_button.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_draft.dart';
import '../../data/models/exercise_target_type.dart';
import 'components/category_quick_picks.dart';
import 'components/exercise_target_fields.dart';

/// Add/edit form for one exercise. Editing prefills every field and
/// preserves the exercise's identity, position, and completion state.
/// Save stays disabled until the whole form is valid; leaving without
/// saving changes nothing.
class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key, this.exerciseToEdit});

  final Exercise? exerciseToEdit;

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _setsController;
  late final TextEditingController _repetitionsController;
  late final TextEditingController _durationController;
  late ExerciseTargetType _targetType;

  bool get _isEditing => widget.exerciseToEdit != null;

  bool get _isDraftValid {
    final String targetText = _targetType == ExerciseTargetType.repetitions
        ? _repetitionsController.text
        : _durationController.text;
    return ExerciseDraftValidator.validateName(_nameController.text) == null &&
        ExerciseDraftValidator.validateCategory(_categoryController.text) ==
            null &&
        ExerciseDraftValidator.validateSets(_setsController.text) == null &&
        ExerciseDraftValidator.validateTarget(_targetType, targetText) == null;
  }

  List<TextEditingController> get _allControllers => <TextEditingController>[
    _nameController,
    _categoryController,
    _setsController,
    _repetitionsController,
    _durationController,
  ];

  @override
  void initState() {
    super.initState();
    final Exercise? exercise = widget.exerciseToEdit;
    _nameController = TextEditingController(text: exercise?.name ?? '');
    _categoryController = TextEditingController(text: exercise?.category ?? '');
    _setsController = TextEditingController(
      text: exercise?.sets.toString() ?? '',
    );
    _repetitionsController = TextEditingController(
      text: exercise?.repetitions?.toString() ?? '',
    );
    _durationController = TextEditingController(
      text: exercise?.durationSeconds?.toString() ?? '',
    );
    _targetType = exercise?.targetType ?? ExerciseTargetType.repetitions;
    for (final TextEditingController controller in _allControllers) {
      controller.addListener(_onFormChanged);
    }
  }

  @override
  void dispose() {
    for (final TextEditingController controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFormChanged() => setState(() {});

  void _saveExercise() {
    final bool countsRepetitions =
        _targetType == ExerciseTargetType.repetitions;
    final ExerciseDraft draft = ExerciseDraft(
      name: _nameController.text,
      category: _categoryController.text,
      targetType: _targetType,
      sets: int.parse(_setsController.text.trim()),
      repetitions: countsRepetitions
          ? int.parse(_repetitionsController.text.trim())
          : null,
      durationSeconds: countsRepetitions
          ? null
          : int.parse(_durationController.text.trim()),
    );
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    if (_isEditing) {
      cubit.updateExercise(widget.exerciseToEdit!.id, draft);
    } else {
      cubit.addExercise(draft);
    }
    NavigationService.pop(null, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? AppStrings.editExerciseTitle
              : AppStrings.addExerciseTitle,
        ),
      ),
      body: SafeArea(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 8.h, 20.w, 24.h),
            children: <Widget>[
              AppTextField(
                controller: _nameController,
                label: AppStrings.nameLabel,
                hint: AppStrings.nameHint,
                fieldKey: AppKeys.nameField,
                validator: ExerciseDraftValidator.validateName,
              ),
              SizedBox(height: 18.h),
              AppTextField(
                controller: _categoryController,
                label: AppStrings.categoryLabel,
                hint: AppStrings.categoryHint,
                fieldKey: AppKeys.categoryField,
                validator: ExerciseDraftValidator.validateCategory,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 10.h),
              CategoryQuickPicks(
                selectedCategory: _categoryController.text,
                onSelected: (String category) =>
                    _categoryController.text = category,
              ),
              SizedBox(height: 22.h),
              ExerciseTargetFields(
                targetType: _targetType,
                onTargetTypeChanged: (ExerciseTargetType type) =>
                    setState(() => _targetType = type),
                setsController: _setsController,
                repetitionsController: _repetitionsController,
                durationController: _durationController,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.h, 20.w, 14.h),
          child: PrimaryActionButton(
            key: AppKeys.saveExerciseButton,
            label: AppStrings.saveExercise,
            onPressed: _isDraftValid ? _saveExercise : null,
          ),
        ),
      ),
    );
  }
}
