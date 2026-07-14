# AI Usage

## Tools used and where they helped

- **Cursor (agent mode, Claude-family model)** — primary tool. Used to:
  - plan the P0/P1 implementation order from the Notion product backlog;
  - scaffold the layered structure (Cubits → repositories → local storage) and write first drafts of models, cubits, repositories, screens, and components;
  - write the unit and widget test suites and iterate until `flutter analyze` and `flutter test` were clean;
  - draft this documentation and the README.
- **AI image generation (via Cursor's image tool)** — produced all bundled artwork: the app icon/brand mark, the three onboarding photographs, the workout hero image, six exercise-category thumbnails, a per-exercise photo set for the starter exercises (including a dedicated reverse-lunge shot), and the empty-state and celebration illustrations. Prompts enforced one consistent art direction (deep navy + cobalt `#2563EB`, same model/studio across photos) so the app feels like one brand rather than stock imagery.

## A generated result that was changed or rejected, and why

Two examples:

1. **Repository API.** The first generated `WorkoutRepository` exposed `resetToStarter()` and `startEmpty()` that both saved and returned snapshots, duplicating the "stamp version + timestamp and persist" logic in three places and hiding a mutation inside what looked like a read path. It was reworked so the repository exposes only `loadWorkout()`, `saveWorkout()`, and `loadStarterExercises()`, and the `WorkoutCubit` owns the single commit path (`_commitSession`) used by every mutation including reset and start-empty. One place stamps and saves; the save-failure/retry behavior became uniform for free.
2. **File-size rule.** Early drafts of the exercise card, form screen, and theme exceeded the 200-line limit from the engineering instructions. They were split into focused parts (`exercise_card_parts.dart`, `exercise_target_fields.dart`, `app_typography.dart`) instead of padding or leaving oversized files.

## How generated work was reviewed and verified

- Every requirement in the backlog (ONB-01…ONB-03, TB-001…TB-064) was mapped to code and re-checked against the acceptance criteria before being marked done.
- `dart format`, `flutter analyze` (zero issues), and `flutter test` (38 tests passing) were run after each significant step, not only at the end.
- Behavior-critical rules — atomic persistence after every mutation, never overwriting corrupt saved data, exact restore of order/completion, celebration firing only on the transition to 100% — are pinned by unit tests using fakes, so regressions fail loudly.
- Widget tests drive the real screens through stable keys (skip/next/back, completion toggles) and assert both the visible progress text and the persisted state.

## Ownership

I can explain every line of submitted code: the layering (screens → cubits → repositories → storage), why the workout is saved as one versioned JSON document, how each explicit state (`loading/ready/empty/failure`) is reached and recovered, how the one-shot celebration flag avoids repeating after restart, and how the tests keep storage and time deterministic.
