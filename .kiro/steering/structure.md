# Project Structure & Architecture

## Root Directory Structure
```
remontada/
├── lib/                    # Main Dart source code
├── assets/                 # Static assets (images, fonts, translations)
├── android/               # Android-specific configuration
├── ios/                   # iOS-specific configuration
├── test/                  # Unit and widget tests
├── packages/              # Local packages (device_uuid)
├── .kiro/                 # Kiro AI assistant configuration
├── env.json              # Environment configuration
├── pubspec.yaml          # Dependencies and project metadata
└── firebase.json         # Firebase configuration
```

## Core Architecture (lib/core/)
```
lib/core/
├── Router/               # Navigation and routing logic
├── app_strings/          # Localization keys and strings
├── config/              # App configuration and constants
├── data_source/         # Network and local storage helpers
├── extensions/          # Dart extensions for common types
├── general/             # Global state management (GeneralCubit)
├── resources/           # Design system (fonts, dimensions, themes)
├── services/            # Utility services (alerts, navigation, media)
├── theme/               # Light/dark theme configurations
└── utils/               # Utility functions and helpers
```

## Feature-Based Structure (lib/features/)
Each feature follows Clean Architecture principles:
```
lib/features/{feature_name}/
├── cubit/               # BLoC state management
│   ├── {feature}_cubit.dart
│   └── {feature}_states.dart
├── domain/              # Business logic layer
│   ├── model/           # Data models
│   ├── repository/      # Repository interfaces
│   └── request/         # Request DTOs
└── presentation/        # UI layer
    ├── screens/         # Screen widgets
    └── widgets/         # Reusable UI components
```

## Current Features
- **auth**: Authentication (login, signup, OTP, password reset)
- **home**: Main dashboard and match discovery
- **layout**: Bottom navigation and main app structure
- **my_matches**: User's matches and match creation
- **matchdetails**: Match information and player management
- **challenges**: Tournaments and team competitions
- **notifications**: Push notifications and alerts
- **player_details**: Individual player profiles
- **profile**: User profile management
- **more**: Settings and additional features
- **splash**: App initialization and onboarding
- **staticScreens**: About, privacy policy, contact pages

## Shared Components (lib/shared/)
```
lib/shared/
├── widgets/             # Reusable UI components
│   ├── button_widget.dart
│   ├── edit_text_widget.dart
│   ├── customAppbar.dart
│   └── ...
└── base_stateless.dart  # Base widget classes
```

## Assets Organization
```
assets/
├── fonts/               # Custom fonts (DINNext Arabic)
├── icons/               # SVG icons
├── images/              # PNG/JPG images
├── json/                # Lottie animations
└── translations/        # Localization files (ar-EG.json, en-US.json)
```

## Naming Conventions
- **Files**: snake_case (e.g., `auth_cubit.dart`)
- **Classes**: PascalCase (e.g., `AuthCubit`)
- **Variables**: camelCase (e.g., `isLoading`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `BASE_URL`)
- **Routes**: camelCase with Screen suffix (e.g., `Routes.LoginScreen`)

## Key Architectural Patterns
- **BLoC Pattern**: All features use Cubit for state management
- **Repository Pattern**: Data access abstraction in domain layer
- **Dependency Injection**: Services registered with get_it
- **Clean Architecture**: Separation of concerns across layers
- **Feature-First**: Code organized by business features, not technical layers

## Navigation Structure
- **Custom Router**: Centralized routing in `lib/core/Router/Router.dart`
- **Route Arguments**: Type-safe argument classes for complex navigation
- **Bottom Navigation**: TabBar-based navigation in LayoutScreen
- **Authentication Flow**: Conditional routing based on token status