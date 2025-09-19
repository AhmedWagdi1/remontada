This repository is a Flutter app named `remontada`. The guidance below is focused, actionable, and limited to patterns discoverable in the codebase so AI coding agents can be immediately productive.

- Use FVM for all Flutter commands. Examples: `fvm use stable`, `fvm flutter pub get`, `fvm flutter run`.

- Entry point and high-level architecture
  - `lib/main.dart` is the application entry. It configures Firebase, Remote Config, Hive, device detection, and global singletons via `setupLocator()`.
  - App wiring uses GetIt (see `core/utils/Locator.dart`) and BLoC for state management (`bloc` / `flutter_bloc` and `core/general/general_cubit.dart`). Create or modify blocs/cubits under `lib/core` and register them in the locator when needed.
  - Routing is centralized in `lib/core/Router/Router.dart` (look for `RouteGenerator.getRoute` and `Routes.*` constants). When adding screens, add a route here and reference it from `initialRoute` or navigation calls.

- Firebase and platform quirks
  - `main.dart` initializes Firebase via `firebase_options.dart`. Firebase may be skipped on platforms without configuration; code contains try/catch to handle this. When changing Firebase usage, mirror the existing defensive pattern.
  - Background messaging uses `FirebaseMessaging.onBackgroundMessage` with `core/utils/firebase_message.dart` — follow that file's structure for message handlers.

- Localization and assets
  - Uses `easy_localization` with assets in `assets/translations` and Arabic default locale (`ar_EG`). Update translations by adding JSON files under `assets/translations` and run `fvm flutter pub get` if you add keys.
  - Fonts, images, and JSON assets are declared in `pubspec.yaml` under `assets:` and `fonts:`. Keep these paths in sync when adding assets.

- State & UI patterns to follow
  - BLoC/Cubit pattern: UI widgets obtain cubits with `BlocProvider` and `BlocConsumer` (see `main.dart` and `core/general`). Follow the existing listener/builder separation.
  - Responsive design uses `flutter_screenutil` and a custom `AppResponsiveWrapper` in `core/utils/responsive_framework_widget.dart`. Use `ScreenUtil` sizes in new widgets for consistency.

- Local storage & services
  - Hive is initialized via `Utils.dataManager.initHive()`; Hive boxes and adapters live under `lib/core` or `lib/core/services`. Use the project's DataManager abstraction rather than calling Hive directly when possible.
  - Device detection uses `core/services/device_type.dart`. For platform-specific code, follow the existing Device API usage.

- Tests and CI
  - Unit tests are under `test/`. Run tests with `fvm flutter test` or the project's test runner. There are test files like `test/auth_cubit_test.dart` and `test/challenges_screen_test.dart` that show how cubits and widgets are tested.
  - The project contains `codemagic.yaml` for CI; follow its build steps if modifying CI behavior.

- Common files to edit for common tasks
  - Add screens/widgets: `lib/features/...` and register route in `lib/core/Router/Router.dart`.
  - Add services/singletons: `lib/core/utils/Locator.dart` and `lib/core/services` (register with GetIt).
  - Add models: `lib/core/models` (or `features/*/models`), and wire up JSON (dio) parsing using existing API helpers.

- Network and API usage
  - HTTP calls use `dio` (see `core` utilities). API responses follow the shape shown in `README.md` for `/team/user-teams` — status/message/data with nested objects. Reuse existing response parsing helpers.

- Linting, formatting, and conventions
  - Project uses standard Dart/Flutter formatting. Run `fvm flutter format .` (or `dart format`) before commits.
  - Follow existing naming: Arabic strings in translations, route names in `Routes.*`, and cubit names like `GeneralCubit`.

- When making changes, prefer low-risk edits
  - Update `pubspec.yaml` when adding packages, then run `fvm flutter pub get`.
  - When modifying Firebase, ensure `firebase_options.dart` remains consistent for each platform and preserve the try/catch fallback in `main.dart` to avoid breaking desktop builds.

If anything above is unclear or you'd like me to expand any section (tests, adding a screen, or how to register a service in the locator), tell me which part and I will iterate.
