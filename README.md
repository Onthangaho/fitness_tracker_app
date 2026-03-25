# Fitness Tracker App

Fitness Tracker is a beginner-friendly Flutter app with a clean workout dashboard, BMI Calculator, and validated custom exercise form.

## Features

- Home screen with:
	- Custom app bar (profile + notifications actions)
	- Welcome greeting
	- Featured workout card
	- BMI Calculator quick-access card
	- Add Exercise flow from FAB via centralized app router
	- Responsive workouts grid (1/2/3 columns based on width)
	- Favorite toggles with snackbar feedback
	- Category tiles wired to type-safe navigation
- Add Exercise screen :
	- `Form` + `GlobalKey<FormState>`
	- `TextEditingController` for all fields with proper dispose
	- Fields: Exercise Name, Sets, Reps, Weight (kg)
	- Production-style validation (type checks + ranges)
	- Required nullable dropdown: Target Muscle Group
	- Live Total Volume preview using controller listeners
	- Full-width save button returning data via `Navigator.pop`
- BMI Calculator screen with:
	- Height + weight input
	- BMI calculation using $BMI = \frac{weight\,(kg)}{height\,(m)^2}$
	- Local state updates via `setState()`
	- Dynamic category feedback (Underweight/Normal/Overweight/Obese)
	- Custom `InkWell`-based button widget

- Assignment 2.1: Native Navigation & Data Passing:
	- Centralized type-safe routing with enhanced enum generics
	- Typed route contracts: `ExerciseListArgs`, `ExerciseDetailArgs`
	- Dynamic AppBar theming from passed `Color` and `IconData`
	- End-to-end navigation flow: Dashboard → Exercise List → Exercise Detail

- Assignment 2.3: State Management with Provider:
	- Multi-provider architecture (ExerciseProvider + RoutineProvider)
	- Browse Exercises screen with real-time routine status tracking
	- Routine Summary screen with comprehensive statistics
	- Computed properties: total volume, total sets, muscle group breakdown
	- Reactive UI updates using `Consumer` widgets
	- Confirmation dialogs for destructive actions (clear routine)
	- Empty state handling with user guidance

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart 3.10.4+
- **State Management**: Provider 6.1.5+
- **UI Toolkit**: Material 3 (`useMaterial3: true`)

## Current Project Structure

```text
lib/
├── app_router.dart
├── main.dart
├── models/
│   └── exercise_model.dart
├── providers/
│   ├── exercise_provider.dart
│   └── routine_provider.dart
├── screens/
│   ├── add_exercise_screen.dart
│   ├── bmi_calculator_screen.dart
│   ├── exercise_browse_screen.dart
│   ├── exercise_detail_screen.dart
│   ├── exercise_list_screen.dart
│   ├── home_screen.dart
│   └── routine_summary_screen.dart
└── widgets/
    ├── app_header.dart
    ├── custom_inkwell_button.dart
    ├── featured_workout_card.dart
    ├── input_card.dart
    ├── notification_badge.dart
    ├── responsive_workouts_grid.dart
    ├── result_display_box.dart
    ├── welcome_greeting.dart
    ├── workout_tile.dart
    └── workouts_section_header.dart
```

## Assignment 2.1 Submission Files

- `lib/app_router.dart`
- `lib/screens/exercise_list_screen.dart`
- `lib/screens/exercise_detail_screen.dart`
- `lib/screens/home_screen.dart` (dashboard wiring)
- `lib/widgets/workout_tile.dart`
- `lib/widgets/responsive_workouts_grid.dart`

## Assignment 2.3 Submission Files

- `lib/providers/routine_provider.dart` (Core state management)
- `lib/screens/exercise_browse_screen.dart` (Browse & add exercises)
- `lib/screens/routine_summary_screen.dart` (View routine stats)
- `lib/app_router.dart` (Updated with new routes)
- `lib/main.dart` (MultiProvider setup)

## Getting Started

### Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A configured device/emulator (Android, iOS, Web, Windows, Linux, or macOS)

### Run Locally

```bash
flutter pub get
flutter run
```

## Useful Commands

```bash
flutter analyze
flutter test
flutter run -d chrome
```

## Notes

- Username currently defaults to `Guest User`.
- Profile, notifications, and view-all actions currently show placeholder snackbars.
- BMI Calculator intentionally uses custom `InkWell` interactions for assignment requirements.
- Custom exercises are validated before being added to the workout list.

## License

This project is licensed under the MIT License. See `LICENSE`.

## Author

Onthangaho Magoro
