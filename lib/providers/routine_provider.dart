import 'dart:async';

import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../data/routine_repository.dart';
import '../models/exercise_model.dart';

class RoutineProvider extends ChangeNotifier {
  final RoutineRepository _repository;
  final AuthService _authService;

  final List<Exercise> _routine = [];
  StreamSubscription<Object?>? _authSubscription;
  String? _activeUserId;

  RoutineProvider(this._repository, this._authService) {
    _initForCurrentUser();
    _authSubscription = _authService.authStateChanges.listen((_) {
      _initForCurrentUser();
    });
  }

  Future<void> _initForCurrentUser() async {
    final userId = _authService.currentUser?.uid;
    _activeUserId = userId;

    _routine.clear();
    if (userId != null) {
      final loadedRoutine = await _repository.loadRoutine(userId);
      _routine.addAll(loadedRoutine);
    }
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
      if (_activeUserId != null) {
        await _repository.saveRoutine(_activeUserId!, _routine);
      }
    }
  }

  Future<void> removeExercise(String id) async {
    _routine.removeWhere((exercise) => exercise.id == id);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveRoutine(_activeUserId!, _routine);
    }
  }

  Future<void> clearRoutine() async {
    _routine.clear();
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveRoutine(_activeUserId!, _routine);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
