# Alsaud Flutter App Prompt Guide

Use this when creating new pages or components in this project.

## Repo layout (lib/)
- `Blocs/`: state management (both Bloc and Cubit patterns).
- `screens/`: feature screens and flows.
- `components/`: app-wide reusable components (reuse these first).
- `widgets/`: additional app-wide reusable widgets.
- `Core/`: theme, constants, services, and shared utilities.
  - `Core/constants/`: app constants (colors, URLs, dimensions, styles).
  - `Core/services/`: services (navigation, network, Firebase, etc.).
  - `Core/Utils/`: helper utilities and cache management.
- `data/`: data layer.
  - `data/models/`: data models.
  - `data/repositories/`: repository classes for API/data access.
- `app_theme/`: theme configuration and extensions.
- `main.dart`: app bootstrap (Firebase, BLoC providers, repository providers, ScreenUtilInit).
- `main_navigation.dart`: bottom navigation bar setup with IndexedStack.

## Screen structure
For each feature screen under `lib/screens/<feature>/`:
- Screen files are typically named `<feature>_screen.dart` or descriptive names.
- Screens should be presentation-only: minimal business logic, delegate to BLoC/Cubit.
- Use `BlocProvider` or `BlocBuilder` to access state management.
- Keep screens focused and refactor into `components/` when widgets get large (max 150 LOC per file).

## UI logic rules
- Files inside `screens/` and `components/` are presentation-only: no business logic and minimal conditional rendering based on raw domain data.
- If the UI needs a variant/state (e.g. status/type), extract it to an `enum` and compute it in the BLoC/Cubit/state, then pass the enum to the UI for rendering.
- Use `BlocBuilder` or `BlocListener` to react to state changes.

## Components (reuse first)
- Before building a new UI control, check `lib/components/` and `lib/widgets/` and reuse an existing component if it fits (or extend it carefully) to keep UI/UX consistent.
- Only create feature-scoped components when the component is not broadly reusable across the app.
- Common component locations:
  - `components/cards/`: card widgets
  - `components/buttons/`: button widgets
  - `components/Inputs/`: input field widgets
  - `components/bottom_sheets/`: bottom sheet widgets

## Routing (MaterialApp + NavigationService)
- Navigation uses `MaterialApp` with `NavigationService.navigatorKey` for global navigation.
- Use `NavigationService` static methods for navigation:
  - `NavigationService.push(Widget page, {BuildContext? context})`: push within current tab
  - `NavigationService.pushRoot(Widget page)`: push to root (hides nav bar)
  - `NavigationService.pushAndRemove(Widget page)`: push and remove previous (for auth flows)
  - `NavigationService.pushReplacement(Widget page, {BuildContext? context})`: replace current screen
  - `NavigationService.pop([result, BuildContext? context])`: pop current screen
- For tab navigation, use `MainNavigation.changeTab(int index)` to switch tabs programmatically.
- When passing data between screens, use constructor parameters or route arguments.

## State management (flutter_bloc)
- Use both `Bloc` and `Cubit` patterns as appropriate.
- BLoCs are registered in `main.dart` using `MultiBlocProvider`.
- Repositories are registered using `MultiRepositoryProvider` in `main.dart`.
- BLoCs/Cubits access repositories via `RepositoryProvider.of<RepositoryType>(context)`.
- Use `Equatable` for state classes when needed for value comparison.
- States typically follow pattern: `Initial`, `Loading`, `Loaded`, `Error`.
- Prefer `BlocBuilder` for UI updates and `BlocListener` for side effects (navigation, snackbars, etc.).

## Create models for request forms
- When a screen has many controllers/variables to prepare a backend payload, create a model in `lib/data/models/`.
- The model should handle serialization (`toJson`), and controllers should be managed in the screen or a dedicated form state class.
- Repositories handle API calls and return models.

## Dependency injection (RepositoryProvider)
- Use `RepositoryProvider` (from flutter_bloc) for app-wide repositories registered in `main.dart`.
- Access repositories in BLoCs via `RepositoryProvider.of<RepositoryType>(context)`.
- Do not create new service locators; register into the existing `MultiRepositoryProvider` in `main.dart`.

## Design + layout rules
- Match Figma/CSS pixel-for-pixel.
- Do not use `Positioned` or absolute positioning for top/left/right values; use `Row`, `Column`, `Stack`, `Align`, `Center`, and spacing instead.
- Width `390px` means full screen width; make layouts responsive.
- Use `flutter_screenutil` (initialized in `main.dart` with `ScreenUtilInit`) for responsive sizing:
  - Use `.w` for width: `16.w`
  - Use `.h` for height: `12.h`
  - Use `.r` for radius: `8.r`
  - Use `.sp` for font size: `14.sp`
- Design size is `Size(390, 844)` as configured in `ScreenUtilInit`.

## Figma implementation (important)
- Treat phone system UI in Figma (status bar/time/battery + bottom home indicator) as OS chrome: do not implement/draw these in Flutter UI.
- Use `Scaffold` + `SafeArea` so content avoids system insets naturally; do not add fake top/bottom bars to match screenshots.
- Figma screens may be LTR (English) only: the implemented UI should support both `en` (LTR) and `ar` (RTL) if needed.
- Build layouts direction-aware:
  - Use `EdgeInsetsDirectional`, `AlignmentDirectional`, and `BorderRadiusDirectional` for horizontal values.
  - Use `Row`/`Wrap` in logical order and rely on `Directionality.of(context)` (start/end) instead of hardcoding left/right.
  - Ensure row item order feels correct in RTL (icons and text placement) by using start/end alignment and direction-aware widgets; do not hardcode LTR ordering.
  - For icons/assets that must mirror in RTL: prefer widgets that support `matchTextDirection` (e.g. `Icon`) or handle RTL manually for custom images/SVGs.

## Text, colors, and styles
- Hardcoded strings are acceptable for now (no localization system detected), but consider extracting to constants for maintainability.
- All text should use theme text styles from `Theme.of(context).textTheme` or custom styles from `AppTheme`.
- All colors come from `AppColorPalette` (`lib/Core/constants/colors.dart`); add new colors there if needed.
- Use theme extensions for custom colors: `Theme.of(context).extension<CustomColors>()` (see `app_theme/theme_extension.dart`).
- Prefer asset constants if available and use appropriate asset loading widgets.

## Theme
- Theme is managed by `ThemeCubit` and defined in `app_theme/app_theme.dart`.
- Use `BlocBuilder<ThemeCubit, ThemeData>` to react to theme changes.
- Custom colors are available via `Theme.of(context).extension<CustomColors>()`.
- Theme supports light/dark modes via `ThemeCubit`.

## Code quality
- Write clean code: each file must not exceed 150 lines of code. Split large files into smaller focused widgets, helpers, or modules.
- Follow `analysis_options.yaml` rules.
- Prefer small focused widgets/files; refactor UI into `components/`/`widgets/` as soon as a `build()` gets large.
- Avoid `print` statements in production code; use proper logging if needed.
- Dispose controllers and listeners in `dispose()` method.

## Naming
- Folders use `PascalCase` (e.g., `Blocs/`, `Core/`) or `camelCase` (e.g., `components/`, `screens/`).
- Files use `snake_case.dart` (e.g., `my_properties_cubit.dart`, `property_view_card.dart`).
- Classes use `PascalCase` (e.g., `PropertyListScreen`, `MyPropertiesCubit`).
- Variables and methods use `camelCase` (e.g., `filterBloc`, `loadMyProperties()`).

## Network and API
- Repositories extend `BaseRepository` (from `Core/services/network_service/base_repository.dart`) for consistent API handling.
- API endpoints are defined in `Core/constants/AppUrls.dart`.
- Use repository pattern: screens → BLoC/Cubit → Repository → API.
- Handle network errors appropriately and emit error states.

## Firebase
- Firebase is initialized in `main.dart`.
- Firebase services are in `Core/services/`:
  - `firebase_notification_service.dart`: push notifications
  - `firebase_storage_service.dart`: file uploads
- Use Firebase services through dedicated service classes, not directly.