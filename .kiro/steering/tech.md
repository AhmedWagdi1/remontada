# Technology Stack

## Framework & Language
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language (SDK >=3.0.5 <4.0.0)
- **FVM**: Flutter Version Management for consistent Flutter versions

## Architecture & State Management
- **BLoC Pattern**: Business Logic Component pattern for state management
- **Clean Architecture**: Feature-based folder structure with domain/presentation layers
- **Dependency Injection**: get_it service locator pattern

## Backend & Services
- **Firebase Core**: Authentication and backend services
- **Firebase Remote Config**: Feature flags and configuration
- **Firebase Messaging**: Push notifications
- **REST API**: Custom backend at `https://match.almasader.net/api`

## Key Libraries
- **Networking**: Dio with pretty_dio_logger for HTTP requests
- **Local Storage**: Hive for local data persistence
- **UI/UX**: flutter_screenutil, responsive_framework, shimmer, lottie
- **Navigation**: Custom router with CupertinoPageRoute
- **Localization**: easy_localization (Arabic/English)
- **Maps**: google_maps_flutter for location services
- **Media**: image_picker, cached_network_image, flutter_svg

## Development Commands

### Setup
```bash
# Install dependencies
fvm flutter pub get

# Clean and reinstall
fvm flutter clean && fvm flutter pub get
```

### Development
```bash
# Run app in debug mode
fvm flutter run

# Run with environment config
fvm flutter run --dart-define-from-file=env.json

# Hot reload is available during development
```

### Testing
```bash
# Run all tests
fvm flutter test

# Run specific test file
fvm flutter test test/auth_cubit_test.dart
```

### Building
```bash
# Debug build
fvm flutter build apk --debug

# Release build with obfuscation
fvm flutter clean && fvm flutter pub get && fvm flutter build apk --dart-define-from-file=env.json --obfuscate --split-debug-info=build/app/outputs/symbols

# iOS build
fvm flutter build ipa --dart-define-from-file=env.json --obfuscate --split-debug-info=build/app/outputs/symbols
```

### Code Generation
```bash
# Generate assets (if using build_runner)
fvm flutter packages pub run build_runner build

# Generate translations
fvm flutter pub run easy_localization:generate
```

## Environment Configuration
- **env.json**: Contains API endpoints and configuration
- **Firebase**: Configured with google-services.json (Android) and GoogleService-Info.plist (iOS)
- **FVM**: Uses .fvmrc for Flutter version management