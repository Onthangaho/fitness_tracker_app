import 'package:flutter/material.dart';
import '../data/routine_repository.dart';
import '../models/exercise_model.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;
  
  final List<Exercise> _routine = [];

  RoutineProvider(this._repository) {
    _init();
  }

  Future<void> _init() async {
    final loadedRoutine = await _repository.loadRoutine();
    _routine.clear();
    _routine.addAll(loadedRoutine);
    notifyListeners();
  }


  List<Exercise> get routine => List.unmodifiable(_routine);

  int get exerciseCount => _routine.length;

  double get totalVolume {
    return _routine.fold<double>(0, (sum, exercise) => sum + exercise.volume);
  }

  int get totalSets {
    return _routine.fold<int>(0, (sum, exercise) => sum + exercise.sets);
  }

  bool isInRoutine(String id) {
    return _routine.any((exercise) => exercise.id == id);
  }

  Map<String, int> get muscleGroupBreakdown {
    final breakdown = <String, int>{};
    for (final exercise in _routine) {
      breakdown[exercise.muscleGroup] =
          (breakdown[exercise.muscleGroup] ?? 0) + 1;
    }
    return breakdown;
  }


  Future<void> addExercise(Exercise exercise) async {
    if (!isInRoutine(exercise.id)) {
      _routine.add(exercise);
      notifyListeners();
      await _repository.saveRoutine(_routine);
    }
  }

  Future<void> removeExercise(String id) async {
    _routine.removeWhere((exercise) => exercise.id == id);
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }

  Future<void> clearRoutine() async {
    _routine.clear();
    notifyListeners();
    await _repository.saveRoutine(_routine);
  }
}
