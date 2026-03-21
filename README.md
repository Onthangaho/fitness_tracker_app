# Fitness Tracker App

Fitness Tracker is a beginner-friendly Flutter app with a clean workout dashboard and a BMI Calculator.

## Features

- Home screen with:
	- Custom app bar (profile + notifications actions)
	- Welcome greeting
	- Featured workout card
	- BMI Calculator quick-access card
	- Responsive workouts grid (1/2/3 columns based on width)
	- Favorite toggles with snackbar feedback
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
- Profile, notifications, view-all, and add-workout actions currently show placeholder snackbars.
- BMI Calculator intentionally uses custom `InkWell` interactions for assignment requirements.

## License

This project is licensed under the MIT License. See `LICENSE`.

## Author

Onthangaho Magoro
