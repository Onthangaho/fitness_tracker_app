import 'package:fitness_tracker_app/screens/exercise_detail_screen.dart';
import 'package:fitness_tracker_app/screens/exercise_list_screen.dart';
import 'package:fitness_tracker_app/screens/add_exercise_screen.dart';
import 'package:fitness_tracker_app/screens/bmi_calculator_screen.dart';
import 'package:fitness_tracker_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ExerciseListArgs {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListArgs({
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });
}
// The ExerciseDetailArgs class is a simple data class that holds the details of an exercise. It includes the exercise name, muscle group, number of sets, reps, and weight. This class is used to pass exercise details as arguments when navigating to the ExerciseDetailScreen.
class ExerciseDetailArgs {
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  const ExerciseDetailArgs({
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}

enum AppRoute<T> {
  home<void>(),
  exerciseList<ExerciseListArgs>(),
  exerciseDetail<ExerciseDetailArgs>(),
  bmiCalculator<void>(),
  addExercise<void>();

  const AppRoute();

  MaterialPageRoute<R> route<R>(T args) {
    switch (this) {
      case AppRoute.home:
        return MaterialPageRoute<R>(
          builder: (_) => const HomeScreen(),
          settings: RouteSettings(name: name),
        );
      case AppRoute.exerciseList:
        final routeArgs = args as ExerciseListArgs;
        return MaterialPageRoute<R>(
          builder: (_) => ExerciseListScreen(
            categoryName: routeArgs.categoryName,
            themeColor: routeArgs.themeColor,
            iconData: routeArgs.iconData,
          ),
          settings: RouteSettings(name: name),
        );
      case AppRoute.exerciseDetail:
        final routeArgs = args as ExerciseDetailArgs;
        return MaterialPageRoute<R>(
          builder: (_) => ExerciseDetailScreen(
            exerciseName: routeArgs.exerciseName,
            muscleGroup: routeArgs.muscleGroup,
            sets: routeArgs.sets,
            reps: routeArgs.reps,
            weight: routeArgs.weight,
          ),
          settings: RouteSettings(name: name),
        );
      case AppRoute.bmiCalculator:
        return MaterialPageRoute<R>(
          builder: (_) => const BMICalculatorScreen(),
          settings: RouteSettings(name: name),
        );
      case AppRoute.addExercise:
        return MaterialPageRoute<R>(
          builder: (_) => const AddExerciseScreen(),
          settings: RouteSettings(name: name),
        );
    }
  }
}

extension AppNavigator on NavigatorState {
  Future<R?> pushRoute<R>(AppRoute<void> route) {
    return push<R>(route.route<R>(null));
  }

  Future<R?> pushRouteWithArgs<R, T>(AppRoute<T> route, T args) {
    return push<R>(route.route<R>(args));
  }
}