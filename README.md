# Fitness Tracker App

Fitness Tracker is a Flutter app built through progressive assignments, now covering authenticated user sessions, outdoor workout tracking, API-powered exercise search, and local notification feedback.

## Assignment Coverage

- Assignment 2.1: Native navigation and typed data passing
- Assignment 2.2: State management with Provider
- Assignment 2.3: Local profile/preferences persistence
- Assignment 3.1: Networking with Dio and external exercise API search
- Assignment 3.2: Outdoor workout tracking with GPS route capture
- Assignment 3.3: Firebase authentication and native local notifications

## Current Features

### Authentication and Routing

- Firebase Email/Password auth flow:
  - Register
  - Login
  - Forgot password
  - Logout with confirmation
- Reactive auth routing with an auth gate:
  - Logged out users see a landing screen first
  - Landing can open Sign In or Create Account views
  - Logged in users are routed to dashboard automatically
- Session validation on startup:
  - Persisted Firebase session is reloaded
  - Invalid/expired sessions are cleared safely

### Security and Error Handling

- Firebase auth errors are mapped to user-friendly messages
- Invalid email/password scenarios use a generic message to prevent account enumeration

### Home and Settings Experience

- Personalized greeting from authenticated email prefix
- Dashboard quick actions and workout cards
- Logout available from both:
  - Home app bar
  - Settings screen
- Settings includes:
  - Profile fields
  - Unit and timer preferences
  - Last signed-in timestamp

### Per-User Local Data Isolation (Important Fix)

- Local profile data is isolated per Firebase user ID
- Local routine data is isolated per Firebase user ID
- Switching accounts no longer leaks profile/goal/routine values across users on the same device

### Outdoor Workout Tracking

- Workout types supported:
  - Walking
  - Running
  - Cycling
- GPS tracking flow:
  - Start workout
  - Update location
  - Finish workout with summary
- Metrics shown:
  - Elapsed time
  - Straight-line distance
  - Route distance
  - Pace
  - Route point count

### Notifications

- Local notifications initialized at app startup
- Separate notification channels for:
  - Workout completion (high priority)
  - Reminders (default priority)
- Workout completion notification content is dynamic based on workout metrics

### Exercise and Utility Screens

- Add Exercise form with validation and controller lifecycle handling
- Routine management with stats and removal/clear actions
- BMI calculator with computed feedback
- API-based exercise search (Assignment 3.1)

## Tech Stack

- Flutter
- Dart 3.10+
- Provider
- Firebase Core
- Firebase Auth
- flutter_local_notifications
- Dio
- geolocator
- shared_preferences

## Setup

### Requirements

- Flutter SDK
- Configured device/emulator (Android, iOS, Web, Windows, Linux, or macOS)
- Firebase project with Email/Password authentication enabled

### Firebase Setup

1. Create or open your Firebase project.
2. Enable Email/Password in Authentication.
3. In this project root, run:

```bash
flutterfire configure
```

4. Ensure generated Firebase config files are present for your selected platforms.

### API Ninjas Key

Pass API key at runtime:

```bash
flutter run --dart-define=API_NINJAS_KEY=YOUR_API_NINJAS_KEY
```

If missing, API search features show an explanatory error state.

## Run and Verify

```bash
flutter pub get
flutter analyze
flutter test
```

Run web:

```bash
flutter run -d chrome --dart-define=API_NINJAS_KEY=YOUR_API_NINJAS_KEY
```

Run Android:

```bash
flutter run -d android --dart-define=API_NINJAS_KEY=YOUR_API_NINJAS_KEY
```

## Current Project Structure

```text
lib/
├── data/
├── domain/
├── models/
├── presentation/
│   ├── screens/
│   └── widgets/
├── providers/
├── firebase_options.dart
└── main.dart
```

## Notes

- Chrome is suitable for testing auth flow and general UI state.
- Native notification permission/banner behavior should be validated on Android/iOS.

## Known Limitations

- Local notifications in this project use `flutter_local_notifications`, so full OS-level notification behavior is validated on Android/iOS rather than Chrome.
- GPS reliability depends on device permissions and location services being enabled.
- If Firebase configuration files are missing on a fresh machine, auth startup fails until `flutterfire configure` is run.

## License

This project is licensed under the MIT License. See LICENSE.

## Author

Onthangaho Magoro
