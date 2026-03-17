# Fitness_Tracker_App
Fitness Tracker is a beginner‑friendly Flutter application designed to help users stay motivated on their fitness journey

## Overview

This project currently includes a starter home screen with:

- A branded app bar (`Fitness Tracker`)
- A welcome message for the current user (defaults to **Guest User**)
- A profile action button (placeholder)
- A floating action button to add future fitness entries (placeholder)

The app is built with Material 3 and a deep orange theme.

## Tech Stack

- Flutter
- Dart
- Material 3 (`useMaterial3: true`)

## Project Structure

Key files:

- `lib/main.dart` – app entry point and UI scaffold
- `test/widget_test.dart` – starter widget test
- `pubspec.yaml` – dependencies and project metadata

## Requirements

Before running the app, make sure you have:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A configured device/emulator (Android, iOS, Web, Windows, Linux, or macOS)
- Dart SDK (included with Flutter)

## Getting Started

1. Clone this repository.
2. Open the project in VS Code or Android Studio.
3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Security and Secrets

- Do not commit local runtime/cache folders such as `.dart_tool/`, `build/`, `.idea/`, and platform ephemeral files.
- If you add third-party API keys later, keep them out of git (for example in local env files or CI secrets) and load them at build/runtime.
- If a key is ever exposed, rotate/revoke it immediately in the provider console and remove it from git history before pushing.

### Fresh clone checklist (new PC)

```bash
flutter clean
flutter pub get
flutter test
flutter run
```

## Useful Commands

```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Run on Chrome
flutter run -d chrome
```

## Current Behavior

- The username is currently not persisted and defaults to `Guest User`.
- The profile icon button and add button are intentionally placeholders for future functionality.

## Roadmap Ideas

- User profile and authentication
- Workout logging (sets, reps, duration)
- Progress charts and history
- Goal setting and reminders
- Local/database/cloud persistence

## Contributing

1. Create a feature branch.
2. Make your changes.
3. Run `flutter analyze` and `flutter test`.
4. Open a pull request.

## License

No license file is currently defined in this repository.

## Created by Onthangaho Magoro
