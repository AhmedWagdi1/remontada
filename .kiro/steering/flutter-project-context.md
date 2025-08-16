# Flutter Project Context

This is a Flutter project named "remontada" that uses FVM (Flutter Version Management) for version control.

## Project Setup
- **Flutter Version**: stable (managed by FVM)
- **SDK Constraint**: >=3.0.5 <4.0.0
- **Version**: 1.0.14+22

## Key Dependencies
- Firebase (Remote Config, Messaging, Core)
- State Management: BLoC pattern (bloc, flutter_bloc)
- Dependency Injection: get_it
- Local Storage: Hive
- Networking: Dio with pretty logging
- UI Components: responsive_framework, flutter_screenutil
- Maps: google_maps_flutter
- Localization: easy_localization

## Development Commands
Always use FVM commands for Flutter operations:
- `fvm flutter pub get` - Install dependencies
- `fvm flutter run` - Run the app
- `fvm flutter build` - Build the app
- `fvm flutter test` - Run tests
- `fvm flutter clean` - Clean build files

## Build Configuration
The project supports obfuscated builds with environment configuration:
```bash
fvm flutter clean && fvm flutter pub get && fvm flutter build ipa --dart-define-from-file=env.json --obfuscate --split-debug-info=build/app/outputs/symbols
```

## Project Structure
- `lib/` - Main Dart source code
- `assets/` - Images, fonts, translations, and other assets
- `packages/device_uuid` - Custom local package
- `android/` - Android-specific configuration
- `ios/` - iOS-specific configuration