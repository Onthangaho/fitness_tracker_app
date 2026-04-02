import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../data/location_service.dart';

enum WorkoutPhase { idle, active, finished }

enum OutdoorWorkoutType { walking, running, cycling }

class WorkoutTrackingProvider extends ChangeNotifier {
  WorkoutTrackingProvider(this._locationService);

  final LocationService _locationService;

  WorkoutPhase _workoutPhase = WorkoutPhase.idle;
  Position? _startPosition;
  Position? _endPosition;
  Position? _currentPosition;
  double _distanceMeters = 0.0;
  double _routeDistanceMeters = 0.0;
  DateTime? _startTime;
  int _elapsedSeconds = 0;
  String? _errorMessage;
  bool _isLoadingLocation = false;
  final List<Position> _routePoints = [];

  Timer? _elapsedTimer;
  Timer? _locationPollingTimer;
  bool _isPollingLocation = false;
  OutdoorWorkoutType _workoutType = OutdoorWorkoutType.running;

  WorkoutPhase get workoutPhase => _workoutPhase;
  Position? get startPosition => _startPosition;
  Position? get endPosition => _endPosition;
  Position? get currentPosition => _currentPosition;
  double get distanceMeters => _distanceMeters;
  double get routeDistanceMeters => _routeDistanceMeters;
  DateTime? get startTime => _startTime;
  int get elapsedSeconds => _elapsedSeconds;
  String? get errorMessage => _errorMessage;
  bool get isLoadingLocation => _isLoadingLocation;
  List<Position> get routePoints => List.unmodifiable(_routePoints);
  OutdoorWorkoutType get workoutType => _workoutType;

  String get workoutTypeLabel {
    switch (_workoutType) {
      case OutdoorWorkoutType.walking:
        return 'Walking';
      case OutdoorWorkoutType.running:
        return 'Running';
      case OutdoorWorkoutType.cycling:
        return 'Cycling';
    }
  }

  void setWorkoutType(OutdoorWorkoutType type) {
    if (_workoutPhase != WorkoutPhase.idle) {
      return;
    }

    if (_workoutType == type) {
      return;
    }

    _workoutType = type;
    notifyListeners();
  }

  Future<void> startWorkout() async {
    _isLoadingLocation = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final startPosition = await _locationService.getCurrentPosition();

      _startPosition = startPosition;
      _currentPosition = startPosition;
      _endPosition = null;
      _distanceMeters = 0.0;
      _routeDistanceMeters = 0.0;
      _elapsedSeconds = 0;
      _startTime = DateTime.now();
      _workoutPhase = WorkoutPhase.active;

      _routePoints
        ..clear()
        ..add(startPosition);

      _startElapsedTimer();
      _startLocationPolling();
    } catch (error) {
      _errorMessage = _normalizeError(error);
      _workoutPhase = WorkoutPhase.idle;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation() async {
    if (_workoutPhase != WorkoutPhase.active) {
      return;
    }

    try {
      final latestPosition = await _locationService.getCurrentPosition();
      _currentPosition = latestPosition;
      _routePoints.add(latestPosition);
      notifyListeners();
    } catch (error) {
      _errorMessage = _normalizeError(error);
      notifyListeners();
    }
  }

  Future<void> finishWorkout() async {
    _isLoadingLocation = true;
    notifyListeners();

    _elapsedTimer?.cancel();
    _locationPollingTimer?.cancel();

    try {
      final endPosition = await _locationService.getCurrentPosition();
      _endPosition = endPosition;
      _currentPosition = endPosition;
      _routePoints.add(endPosition);

      if (_startPosition != null) {
        _distanceMeters = _locationService.calculateDistance(
          _startPosition!.latitude,
          _startPosition!.longitude,
          _endPosition!.latitude,
          _endPosition!.longitude,
        );
      }

      _routeDistanceMeters = _calculateRouteDistance();
      _workoutPhase = WorkoutPhase.finished;
    } catch (error) {
      _errorMessage = _normalizeError(error);
      _routeDistanceMeters = _calculateRouteDistance();
      _workoutPhase = WorkoutPhase.finished;
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void resetWorkout() {
    _elapsedTimer?.cancel();
    _locationPollingTimer?.cancel();

    _workoutPhase = WorkoutPhase.idle;
    _startPosition = null;
    _endPosition = null;
    _currentPosition = null;
    _distanceMeters = 0.0;
    _routeDistanceMeters = 0.0;
    _startTime = null;
    _elapsedSeconds = 0;
    _errorMessage = null;
    _isLoadingLocation = false;
    _isPollingLocation = false;
    _routePoints.clear();
    _workoutType = OutdoorWorkoutType.running;

    notifyListeners();
  }

  String get formattedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedDistance => _formatMeters(_distanceMeters);

  String get formattedRouteDistance => _formatMeters(_routeDistanceMeters);

  String get formattedPace {
    final selectedDistance = _routeDistanceMeters > 0
        ? _routeDistanceMeters
        : _distanceMeters;

    if (selectedDistance <= 0 || _elapsedSeconds <= 0) {
      return '--';
    }

    final secondsPerKilometer = (_elapsedSeconds / (selectedDistance / 1000))
        .round();
    final paceMinutes = secondsPerKilometer ~/ 60;
    final paceSeconds = secondsPerKilometer % 60;

    return '$paceMinutes:${paceSeconds.toString().padLeft(2, '0')} min/km';
  }

  bool get canFinish => _workoutPhase == WorkoutPhase.active;

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds += 1;
      notifyListeners();
    });
  }

  void _startLocationPolling() {
    _locationPollingTimer?.cancel();
    _locationPollingTimer = Timer.periodic(const Duration(seconds: 10), (
      _,
    ) async {
      if (_workoutPhase != WorkoutPhase.active || _isPollingLocation) {
        return;
      }

      _isPollingLocation = true;
      try {
        final latestPosition = await _locationService.getCurrentPosition();
        _currentPosition = latestPosition;
        _routePoints.add(latestPosition);
        notifyListeners();
      } catch (_) {
        // Skip failed polling points to keep workout tracking alive.
      } finally {
        _isPollingLocation = false;
      }
    });
  }

  double _calculateRouteDistance() {
    if (_routePoints.length < 2) {
      return 0.0;
    }

    var totalDistance = 0.0;
    for (var i = 0; i < _routePoints.length - 1; i++) {
      final start = _routePoints[i];
      final end = _routePoints[i + 1];
      totalDistance += _locationService.calculateDistance(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );
    }

    return totalDistance;
  }

  String _formatMeters(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _normalizeError(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }
    return message;
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    _locationPollingTimer?.cancel();
    super.dispose();
  }
}
