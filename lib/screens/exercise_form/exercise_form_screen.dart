import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/workout/workout_cubit.dart';
import '../../Core/constants/app_strings.dart';
import '../../Core/constants/colors.dart';
import '../../Core/services/navigation_service.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_target_type.dart';
import 'components/exercise_form_controllers.dart';
import 'components/exercise_form_hero.dart';
import 'components/exercise_form_save_bar.dart';
import 'components/exercise_form_sheet.dart';

/// Add/edit form for one exercise. Editing prefills fields and preserves
/// identity, position, and completion. Save stays disabled until valid.
class ExerciseFormScreen extends StatefulWidget {
  const ExerciseFormScreen({super.key, this.exerciseToEdit});

  final Exercise? exerciseToEdit;

  @override
  State<ExerciseFormScreen> createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  late final ExerciseFormControllers _form;
  late String _heroName;
  late String _heroCategory;

  bool get _isEditing => widget.exerciseToEdit != null;

  @override
  void initState() {
    super.initState();
    final Exercise? exercise = widget.exerciseToEdit;
    _form = ExerciseFormControllers(exercise: exercise);
    _heroName = exercise?.name ?? '';
    _heroCategory = exercise?.category ?? '';
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _onCategoryCommitted(String category) {
    final String next = category.trim();
    final String? original = widget.exerciseToEdit?.category;
    final String nextName =
        original != null && original.trim().toLowerCase() == next.toLowerCase()
        ? (widget.exerciseToEdit?.name ?? '')
        : '';
    if (next == _heroCategory && nextName == _heroName) return;
    setState(() {
      _heroCategory = next;
      _heroName = nextName;
    });
  }

  void _saveExercise() {
    final WorkoutCubit cubit = context.read<WorkoutCubit>();
    if (_isEditing) {
      cubit.updateExercise(widget.exerciseToEdit!.id, _form.toDraft());
    } else {
      cubit.addExercise(_form.toDraft());
    }
    NavigationService.pop(null, context);
  }

  @override
  Widget build(BuildContext context) {
    final String title = _isEditing
        ? AppStrings.editExerciseTitle
        : AppStrings.addExerciseTitle;
    return Scaffold(
      backgroundColor: AppColorPalette.iceBackground,
      body: Form(
        autovalidateMode: AutovalidateMode.disabled,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ExerciseFormHero(
                title: title,
                name: _heroName,
                category: _heroCategory,
              ),
            ),
            SliverToBoxAdapter(
              child: ExerciseFormSheet(
                nameController: _form.name,
                categoryController: _form.category,
                setsController: _form.sets,
                repetitionsController: _form.repetitions,
                durationController: _form.duration,
                targetType: _form.targetType,
                onTargetTypeChanged: (ExerciseTargetType type) =>
                    setState(() => _form.targetType = type),
                onCategoryCommitted: _onCategoryCommitted,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _form.listenable,
        builder: (BuildContext context, Widget? _) => ExerciseFormSaveBar(
          onPressed: _form.isValid ? _saveExercise : null,
        ),
      ),
    );
  }
}
