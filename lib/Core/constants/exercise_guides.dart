import '../../data/models/exercise_guide.dart';

/// Coaching content for the starter exercises, with category-level fallbacks
/// so user-created exercises still get a helpful detail page.
class ExerciseGuideLibrary {
  ExerciseGuideLibrary._();

  static const Map<String, ExerciseGuide> _byExerciseName =
      <String, ExerciseGuide>{
        'squat': ExerciseGuide(
          summary:
              'The foundational lower-body strength move for quads, glutes, '
              'and core.',
          steps: <String>[
            'Stand with feet shoulder-width apart, toes slightly out.',
            'Brace your core and send your hips back and down.',
            'Lower until thighs are about parallel with the floor.',
            'Drive through your heels to stand tall again.',
          ],
          tips: <String>[
            'Keep your chest proud and spine neutral the whole way down.',
            'Knees track over toes — never let them cave inward.',
            'Exhale on the way up, inhale on the way down.',
          ],
          equipment: <String>[],
        ),
        'push-up': ExerciseGuide(
          summary:
              'A full-body pressing movement for chest, shoulders, triceps, '
              'and trunk control.',
          steps: <String>[
            'Start in a high plank, hands under shoulders.',
            'Lower your chest toward the floor in one straight line.',
            'Stop just above the floor, elbows at roughly 45 degrees.',
            'Press the floor away until your arms are fully extended.',
          ],
          tips: <String>[
            'Squeeze glutes and core so your hips never sag.',
            'Drop to your knees to keep perfect form when tired.',
          ],
          equipment: <String>['Exercise mat'],
        ),
        'bent-over row': ExerciseGuide(
          summary:
              'A hip-hinge pulling exercise that strengthens the lats, '
              'rhomboids, and rear shoulders.',
          steps: <String>[
            'Hold your weights and hinge forward from the hips, back flat.',
            'Let the arms hang straight down, palms facing each other.',
            'Pull the weights toward your ribs, elbows brushing your sides.',
            'Lower with control until your arms are long again.',
          ],
          tips: <String>[
            'Lead the pull with your elbows, not your hands.',
            'Keep your neck long — eyes on the floor slightly ahead.',
          ],
          equipment: <String>['Pair of dumbbells'],
        ),
        'reverse lunge': ExerciseGuide(
          summary:
              'A knee-friendly single-leg move for glutes, quads, and '
              'balance.',
          steps: <String>[
            'Stand tall with feet hip-width apart, hands at your chest.',
            'Step one foot straight back onto the ball of the foot.',
            'Bend both knees until the back knee hovers above the mat.',
            'Push through the front heel to return, then switch legs.',
          ],
          tips: <String>[
            'Keep your torso upright — think elevator, not escalator.',
            'The front knee stays stacked over the ankle.',
          ],
          equipment: <String>['Exercise mat'],
        ),
        'plank': ExerciseGuide(
          summary:
              'An isometric hold that builds deep core strength and full-body '
              'tension.',
          steps: <String>[
            'Place forearms on the mat, elbows under shoulders.',
            'Step your feet back into one straight line, head to heels.',
            'Squeeze glutes, tuck ribs, and hold the position.',
            'Breathe steadily until the timer ends.',
          ],
          tips: <String>[
            'Push the floor away to keep shoulder blades active.',
            'If your hips drop, rest and restart rather than sag.',
          ],
          equipment: <String>['Exercise mat'],
        ),
        'jumping jacks': ExerciseGuide(
          summary:
              'A classic cardio burst that raises the heart rate and warms '
              'the whole body.',
          steps: <String>[
            'Stand tall, arms at your sides, knees soft.',
            'Jump your feet wide while sweeping your arms overhead.',
            'Jump back to the start position in one smooth beat.',
            'Keep a light, springy rhythm for the whole interval.',
          ],
          tips: <String>[
            'Land softly on the balls of your feet.',
            'Slow the tempo instead of stopping if you need a breather.',
          ],
          equipment: <String>[],
        ),
      };

  static const Map<String, ExerciseGuide> _byCategory = <String, ExerciseGuide>{
    'legs': ExerciseGuide(
      summary: 'A lower-body exercise for strong legs and glutes.',
      steps: <String>[
        'Set your stance and brace your core before each rep.',
        'Move slowly through the full range you control.',
        'Drive back to the start through your heels.',
      ],
      tips: <String>[
        'Keep knees tracking over toes.',
        'Own the lowering phase — no dropping.',
      ],
      equipment: <String>[],
    ),
    'chest': ExerciseGuide(
      summary: 'A pressing movement for chest, shoulders, and triceps.',
      steps: <String>[
        'Set a strong plank or braced position first.',
        'Lower with control, keeping elbows near 45 degrees.',
        'Press away powerfully without losing your body line.',
      ],
      tips: <String>['Never let the hips sag.', 'Exhale as you press.'],
      equipment: <String>['Exercise mat'],
    ),
    'back': ExerciseGuide(
      summary: 'A pulling movement for a strong, healthy upper back.',
      steps: <String>[
        'Hinge or set your position with a flat back.',
        'Pull with your elbows toward your ribs.',
        'Lower slowly until your arms are long.',
      ],
      tips: <String>[
        'Squeeze shoulder blades together at the top.',
        'Keep your neck relaxed.',
      ],
      equipment: <String>['Pair of dumbbells'],
    ),
    'core': ExerciseGuide(
      summary: 'A trunk exercise for stability and control.',
      steps: <String>[
        'Set your spine neutral and brace your core.',
        'Move (or hold) without letting your hips shift.',
        'Breathe steadily — never hold your breath.',
      ],
      tips: <String>['Quality beats duration: stop when form breaks.'],
      equipment: <String>['Exercise mat'],
    ),
    'cardio': ExerciseGuide(
      summary: 'A conditioning burst to raise your heart rate.',
      steps: <String>[
        'Start at a rhythm you can keep for the whole interval.',
        'Stay light on your feet with soft knees.',
        'Finish strong through the final seconds.',
      ],
      tips: <String>['Slow down rather than stopping completely.'],
      equipment: <String>[],
    ),
  };

  static const ExerciseGuide _generic = ExerciseGuide(
    summary: 'Your custom exercise — perform it with intent and control.',
    steps: <String>[
      'Set up with good posture and a braced core.',
      'Move through a controlled, pain-free range of motion.',
      'Keep every repetition smooth and deliberate.',
    ],
    tips: <String>[
      'Pick a pace you could keep for every set.',
      'Stop the set early if your form starts to slip.',
    ],
    equipment: <String>[],
  );

  /// Guide for a specific exercise, its category, or a safe generic default.
  static ExerciseGuide guideFor(String name, String category) {
    return _byExerciseName[name.trim().toLowerCase()] ??
        _byCategory[category.trim().toLowerCase()] ??
        _generic;
  }
}
