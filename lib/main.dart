import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/profile_repository.dart';
import 'data/routine_repository.dart';

import 'providers/routine_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/profile_provider.dart';

import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profileRepository = ProfileRepository();
    final routineRepository = RoutineRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(profileRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RoutineProvider(routineRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ExerciseProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

