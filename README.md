# TrainInBlue

TrainInBlue is an offline-first Flutter app for building, organizing, completing, and safely resuming a single workout session. It ships with six starter exercises from bundled JSON, saves every change on the device, and restores an unfinished session exactly after the app is closed and reopened. Tapping any exercise opens a full detail experience: its own AI-generated photo, key numbers, an interactive set tracker (for rep exercises) or a foreground countdown timer (for duration exercises), step-by-step coaching content, and complete/edit/delete actions. There is no backend, no account, and no network requirement.

## Screenshots

> Placeholder — run the app and capture: splash, the three onboarding pages, workout home (partial progress), the add/edit form, delete/reset confirmations, and the completion celebration.

## Requirements

- Flutter **3.41.x** (stable) with Dart 3.11 — verify with `flutter --version`
- An iOS simulator or Android emulator/device

## Run from a clean checkout

```bash
flutter pub get
flutter run
```

Useful commands:

| Task | Command |
| --- | --- |
| Run the app | `flutter run` |
| Format | `dart format lib test` |
| Analyze | `flutter analyze` |
| Tests | `flutter test` |
| Regenerate launcher icons | `dart run flutter_launcher_icons` |

## Architecture

Layers are separated so each responsibility lives in exactly one place; screens render state and dispatch intent, the cubit owns rules and persistence ordering, and repositories own storage details.

```
UI (screens/, components/, widgets/)
        │  render state / dispatch intent
        ▼
WorkoutCubit · OnboardingCubit · ThemeCubit   (Blocs/)
        │  load / mutate / persist
        ▼
WorkoutRepository · OnboardingRepository      (data/repositories/)
        │
        ├── LocalStorageService (SharedPreferences)   ← source of truth
        └── assets/data/exercises.json                ← first launch only
```

### Folder structure

```
lib/
  Blocs/            # Cubits: workout session, onboarding flag, theme
  screens/          # splash, onboarding, workout home, exercise detail, form
  components/       # reusable cards, buttons, Inputs, dialogs, progress
  widgets/          # small shared widgets (status view, page dots)
  Core/
    constants/      # colors, strings, asset paths, widget keys
    services/       # LocalStorageService, NavigationService
    Utils/          # validators, duration formatter, id generator
    errors/         # readable application exceptions
  data/
    models/         # Exercise, drafts, snapshot, progress
    repositories/   # local workout + onboarding repositories
  app_theme/        # Material 3 theme, typography, color extension
assets/
  data/exercises.json   # six starter exercises, both target types
  images/, branding/, fonts/
test/
  unit/  widget/  helpers/
```

### State management decision

`flutter_bloc` with **Cubits**. The app has one aggregate (the active workout), so a single `WorkoutCubit` is the source of truth: it owns loading, every mutation, persistence, and error handling, and derives progress (completed/total/remaining/percent) in exactly one place (`WorkoutProgress`). Explicit states (`loading`, `ready`, `empty`, `failure`) keep every UI situation intentional. Event-modeling with full Blocs would add ceremony without value at this size.

### Persistence decision

`shared_preferences` stores the whole workout as **one versioned JSON document** (`schemaVersion`, `updatedAt`, exercises with order and completion). The workout is small, so atomic whole-document saves after every successful mutation are simpler and safer than field-level writes — a save either fully succeeds or the previous document stays intact. Corrupt saved data is **never silently overwritten**; the user gets an explicit recovery choice (try again / start empty). Bundled starter JSON is read only when no saved workout exists.

### Dependency rationale

| Package | Why |
| --- | --- |
| `flutter_bloc` | Cubit state management; one source of truth with testable mutations |
| `equatable` | Value equality for states/models → predictable rebuilds |
| `shared_preferences` | Tiny, reliable key-value store for the single JSON snapshot |
| `flutter_screenutil` | Responsive sizing against the 390×844 design canvas |
| `cupertino_icons` | Default iOS-style icon set |
| `flutter_launcher_icons` (dev) | Generates Android/iOS launcher icons from the brand mark |
| `flutter_lints` (dev) | Recommended lint set enforced by `flutter analyze` |

## Testing

- **Unit** — progress calculation (empty/partial/complete/rounding), `Exercise`/`WorkoutSnapshot` JSON round-trips and invalid-data rejection, every `WorkoutCubit` mutation including persistence, save-failure retry, celebration one-shot, and recovery paths; repository behavior over mocked storage including corrupt-data protection.
- **Widget** — onboarding navigation (Next/Back/Skip/final CTA with persisted completion); the workout screen: completing/reopening an exercise updates progress and persists, empty state shows safe 0%; the detail flow: card tap opens the detail screen, completing there persists and updates home progress, the set tracker counts taps, the countdown timer runs to zero, and delete-from-detail returns home.
- Fakes replace device storage (`FakeWorkoutRepository`, `SharedPreferences.setMockInitialValues`); an injectable clock and ID generator keep tests deterministic.

Run everything with `flutter test`.

## Assumptions

- One workout session at a time; no templates or history (per scope).
- Categories are free text with quick-pick suggestions. Known starter exercises get their own AI-generated photo; anything else falls back to a category image (Legs, Chest, Back, Core, Cardio) and then to a generic image, so custom exercises always render.
- Coaching content (steps/tips/equipment) is bundled for the six starter exercises with category-level fallbacks for custom exercises.
- The set timer on the detail screen is foreground-only by design; the background timer remains a design answer (below), per scope.
- Onboarding completion and the workout snapshot are independent keys; a corrupt onboarding flag simply re-shows onboarding.
- English copy only, but layouts use directional widgets (`EdgeInsetsDirectional`, start/end alignment) so RTL locales lay out correctly.

## Known limitations / unfinished work

- Light theme only (a `ThemeCubit` exists, so a dark palette is a follow-up, not a rewrite).
- No haptics; celebrations are a simple dialog.
- Strings are centralized but not wired to a localization framework.
- Large source PNGs are bundled as-is; compressing them would trim app size.

### Next steps

1. Dark mode palette via the existing `CustomColors` extension.
2. Background-safe rest/set timer using the design below (the current set timer is foreground-only).
3. Undo snackbar for deletes, in addition to confirmation.

## Background timer design (design answer only — not implemented)

Persist `startedAt`, accumulated elapsed time, and a paused/running flag. A `Ticker` only refreshes the visible UI; it is never the source of truth. On resume (or after process death), recompute elapsed time from the current clock and the saved timestamps rather than assuming a Dart timer kept running in the background. For countdowns, persist the absolute **end** timestamp and derive remaining time from it.

Inject a clock for deterministic tests. Test: start, pause, resume, background/foreground transitions, process termination and restoration, expiration while suspended, and clock boundaries — with lifecycle-aware widget tests plus real-device checks on iOS and Android. If the user must be alerted while the app is suspended, schedule a **local notification** at the end timestamp instead of relying on a background Dart timer.
