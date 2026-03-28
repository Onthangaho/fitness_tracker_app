import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

class ExerciseProvider extends ChangeNotifier {
  static final List<Exercise> _defaultExercises = [
    Exercise(
      id: '1',
      name: 'Bench Press',
      muscleGroup: 'Chest',
      sets: 3,
      reps: 10,
      weight: 80.0,
    ),
    Exercise(
      id: '2',
      name: 'Incline Dumbbell Press',
      muscleGroup: 'Chest',
      sets: 3,
      reps: 12,
      weight: 35.0,
    ),
    Exercise(
      id: '3',
      name: 'Cable Flyes',
      muscleGroup: 'Chest',
      sets: 3,
      reps: 15,
      weight: 20.0,
    ),
    Exercise(
      id: '4',
      name: 'Lat Pulldown',
      muscleGroup: 'Back',
      sets: 4,
      reps: 10,
      weight: 60.0,
    ),
    Exercise(
      id: '5',
      name: 'Barbell Rows',
      muscleGroup: 'Back',
      sets: 4,
      reps: 8,
      weight: 100.0,
    ),
    Exercise(
      id: '6',
      name: 'Leg Press',
      muscleGroup: 'Legs',
      sets: 3,
      reps: 12,
      weight: 150.0,
    ),
    Exercise(
      id: '7',
      name: 'Leg Curls',
      muscleGroup: 'Legs',
      sets: 3,
      reps: 12,
      weight: 60.0,
    ),
    Exercise(
      id: '8',
      name: 'Shoulder Press',
      muscleGroup: 'Shoulders',
      sets: 3,
      reps: 10,
      weight: 50.0,
    ),
  ];

  
  late final List<Exercise> _exercises = List.from(_defaultExercises);

  

  List<Exercise> get exercises => List.unmodifiable(_exercises);

  int get exerciseCount => _exercises.length;
}
