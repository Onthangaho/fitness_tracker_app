# Fitness Tracker App

Fitness Tracker is a beginner-friendly Flutter app that helps users stay motivated with a clean home dashboard, workout cards, and quick feedback actions.

## Overview

This project currently includes:

- A branded app bar with profile and notifications actions
- A welcome section for the current user (defaults to Guest User)
- A featured workout card with a call-to-action button
- A responsive workouts grid (1/2/3 columns depending on width)
- Favorite toggle interactions and snack-bar feedback
- Reusable workout card widget rendering each workout tile

The app is built with Material 3 and a deep orange theme.

## Tech Stack

- Flutter
- Dart
- Material 3 (`useMaterial3: true`)

## Project Structure

Key files:

- `lib/main.dart` - app entry point, theme, home screen, and responsive layout
- `lib/workout_tile.dart` - reusable workout tile UI component
- `test/widget_test.dart` - home screen smoke test
- `pubspec.yaml` - dependencies, SDK constraint, and assets

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

- Username is currently not persisted and defaults to Guest User.
- Profile/notifications/view-all actions currently show snack-bar placeholders.
- Featured workout start action shows a snack-bar confirmation.
- Workout favorites can be toggled from each tile.

## Troubleshooting

- If dependency install fails, run:

```bash
dart pub get --no-example
```

- If VS Code still reports stale `pubspec.yaml` parsing errors after a fix:
	- Save the file
	- Run **Dart: Restart Analysis Server** from the Command Palette
	- Re-run `dart pub get --no-example`

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
