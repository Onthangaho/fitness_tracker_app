# Fitness Tracker App

Fitness Tracker is a beginner-friendly Flutter app with a clean workout dashboard, BMI Calculator, and validated custom exercise form.

## Features

- Home screen with:
	- Custom app bar (profile + notifications actions)
	- Welcome greeting
	- Featured workout card
	- BMI Calculator quick-access card
	- Add Exercise flow from FAB (`await Navigator.push(...)`)
	- Responsive workouts grid (1/2/3 columns based on width)
	- Favorite toggles with snackbar feedback
- Add Exercise screen (Assignment 1.3B):
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

## Tech Stack

- Flutter
- Dart
- Material 3 (`useMaterial3: true`)

## Current Project Structure

```text
lib/
├── add_exercise_screen.dart
├── main.dart
├── workout_tile.dart
├── screens/
│   ├── home_screen.dart
│   └── bmi_calculator_screen.dart
└── widgets/
		├── app_header.dart
		├── custom_inkwell_button.dart
		├── featured_workout_card.dart
		├── input_card.dart
		├── notification_badge.dart
		├── responsive_workouts_grid.dart
		├── result_display_box.dart
		├── welcome_greeting.dart
		└── workouts_section_header.dart
```

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
