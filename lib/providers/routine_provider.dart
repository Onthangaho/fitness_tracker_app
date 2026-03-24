import 'package:flutter/material.dart';
import '../models/exercise_model.dart';

/// Global state manager for the user's daily routine
class RoutineProvider extends ChangeNotifier {
  // Private state
  final List<Exercise> _routine = [];

  // ==================== GETTERS (Read-only access) ====================

  /// Returns the list of exercises in the routine
  List<Exercise> get routine => List.unmodifiable(_routine);

  /// Returns the number of exercises in the routine
  int get exerciseCount => _routine.length;

  /// Returns the total volume (sum of all exercise volumes)
  double get totalVolume {
    return _routine.fold<double>(0, (sum, exercise) => sum + exercise.volume);
  }

  /// Returns the total sets across all exercises
  int get totalSets {
    return _routine.fold<int>(0, (sum, exercise) => sum + exercise.sets);
  }

  /// Checks if an exercise with the given ID is already in the routine
  bool isInRoutine(String id) {
    return _routine.any((exercise) => exercise.id == id);
  }

  /// Returns a breakdown of exercises per muscle group
  /// Example: {'Chest': 3, 'Back': 2, 'Legs': 1}
  Map<String, int> get muscleGroupBreakdown {
    final breakdown = <String, int>{};
    for (final exercise in _routine) {
      breakdown[exercise.muscleGroup] =
          (breakdown[exercise.muscleGroup] ?? 0) + 1;
    }
    return breakdown;
  }

  // ==================== MUTATION METHODS ====================

  /// Adds an exercise to the routine
  /// If an exercise with the same ID already exists, does nothing
  void addExercise(Exercise exercise) {
    if (!isInRoutine(exercise.id)) {
      _routine.add(exercise);
      notifyListeners();
    }
  }

  /// Removes an exercise from the routine by ID
  void removeExercise(String id) {
    _routine.removeWhere((exercise) => exercise.id == id);
    notifyListeners();
  }

  /// Clears all exercises from the routine
  void clearRoutine() {
    _routine.clear();
    notifyListeners();
  }
}
