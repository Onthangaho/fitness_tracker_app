import 'package:flutter/material.dart';

import '../data/exercise_api_repository.dart';
import '../data/models/api_exercise.dart';

class ExerciseSearchProvider extends ChangeNotifier {
  final ExerciseApiRepository _repository;

  ExerciseSearchProvider(this._repository);

  List<ApiExercise> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _lastQuery = '';
  String? _lastMuscle;
  String? _lastType;
  String? _lastDifficulty;
  String? _lastName;

  List<ApiExercise> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get lastQuery => _lastQuery;

  bool get hasResults => _searchResults.isNotEmpty;
  bool get hasError => _errorMessage != null;

  Future<void> searchExercises({
    String? muscle,
    String? type,
    String? difficulty,
    String? name,
  }) async {
    final normalizedMuscle = muscle?.trim().toLowerCase() ?? '';
    final normalizedType = type?.trim().toLowerCase() ?? '';
    final normalizedDifficulty = difficulty?.trim().toLowerCase() ?? '';
    final normalizedName = name?.trim().toLowerCase() ?? '';

    if (normalizedMuscle.isEmpty &&
        normalizedType.isEmpty &&
        normalizedDifficulty.isEmpty &&
        normalizedName.isEmpty) {
      return;
    }

    _lastMuscle = normalizedMuscle.isEmpty ? null : normalizedMuscle;
    _lastType = normalizedType.isEmpty ? null : normalizedType;
    _lastDifficulty = normalizedDifficulty.isEmpty
        ? null
        : normalizedDifficulty;
    _lastName = normalizedName.isEmpty ? null : normalizedName;

    final queryParts = <String>[
      if (_lastMuscle != null) 'muscle: ${_lastMuscle!}',
      if (_lastType != null) 'type: ${_lastType!}',
      if (_lastDifficulty != null) 'difficulty: ${_lastDifficulty!}',
      if (_lastName != null) 'name: ${_lastName!}',
    ];
    _lastQuery = queryParts.join(', ');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.searchExercises(
        muscle: _lastMuscle,
        type: _lastType,
        difficulty: _lastDifficulty,
        name: _lastName,
      );
      _searchResults = results;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry() async {
    if (_lastMuscle == null &&
        _lastType == null &&
        _lastDifficulty == null &&
        _lastName == null) {
      return;
    }

    await searchExercises(
      muscle: _lastMuscle,
      type: _lastType,
      difficulty: _lastDifficulty,
      name: _lastName,
    );
  }

  void clearResults() {
    _searchResults = [];
    _isLoading = false;
    _errorMessage = null;
    _lastQuery = '';
    _lastMuscle = null;
    _lastType = null;
    _lastDifficulty = null;
    _lastName = null;
    notifyListeners();
  }
}
