import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/auth_service.dart';
import 'data/notification_service.dart';
import 'data/profile_repository.dart';
import 'data/routine_repository.dart';
import 'data/exercise_api_repository.dart';

import 'providers/routine_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/profile_provider.dart';
import 'domain/auth_provider.dart';
import 'domain/exercise_search_provider.dart';
import 'domain/workout_tracking_provider.dart';
import 'data/location_service.dart';
import 'firebase_options.dart';

import 'presentation/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profileRepository = ProfileRepository();
    final routineRepository = RoutineRepository();
    final exerciseApiRepository = ExerciseApiRepository();
    final authService = AuthService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(profileRepository, authService),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(routineRepository, authService),
        ),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(
          create: (_) => ExerciseSearchProvider(exerciseApiRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkoutTrackingProvider(LocationService()),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const AuthGate(),
      ),
    );
  }
}
