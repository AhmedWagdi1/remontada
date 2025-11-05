
# Remontada Flutter Project

## Project Overview

This is a Flutter project named "Remontada". It's a mobile application for both Android and iOS. The app is designed to be a social platform for football enthusiasts, allowing them to create and manage teams, organize matches, and participate in challenges.

The project is well-structured, following the feature-first approach. It uses `flutter_bloc` for state management, `dio` for networking, and `easy_localization` for internationalization. It also integrates with Firebase for push notifications and remote configuration.

## Building and Running

This project uses FVM (Flutter Version Management) to ensure the correct Flutter SDK is used. To build and run the project, follow these steps:

1.  **Install FVM:**
    ```bash
    dart pub global activate fvm
    ```

2.  **Install the correct Flutter version:**
    ```bash
    fvm install
    ```

3.  **Get dependencies:**
    ```bash
    fvm flutter pub get
    ```

4.  **Run the app:**
    ```bash
    fvm flutter run
    ```

## Development Conventions

*   **State Management:** The project uses the BLoC pattern for state management. All BLoC-related files are located in the `lib/features` directory, under the respective feature.
*   **Routing:** The app uses a centralized routing system, managed by the `RouteGenerator` class in `lib/core/Router/Router.dart`.
*   **Localization:** The project uses the `easy_localization` package for internationalization. All translation files are located in the `assets/translations` directory.
*   **CI/CD:** The project uses Codemagic for continuous integration and deployment. The configuration is defined in the `codemagic.yaml` file. The workflow is set up to automatically build and deploy the iOS app to TestFlight when code is pushed to the `main` branch.

## Key Files

*   `pubspec.yaml`: Defines the project's dependencies and metadata.
*   `lib/main.dart`: The entry point of the application.
*   `lib/core/Router/Router.dart`: Defines all the routes in the application.
*   `codemagic.yaml`: Defines the CI/CD workflow for the project.
*   `lib/features`: Contains all the features of the application, following the feature-first approach.
*   `assets/translations`: Contains the translation files for the application.
