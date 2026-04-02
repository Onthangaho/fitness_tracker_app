import 'dart:async';

import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;
  final AuthService _authService;

  UserProfile _profile = UserProfile.defaults();
  StreamSubscription<Object?>? _authSubscription;
  String? _activeUserId;

  ProfileProvider(this._repository, this._authService) {
    _initForCurrentUser();
    _authSubscription = _authService.authStateChanges.listen((_) {
      _initForCurrentUser();
    });
  }

  Future<void> _initForCurrentUser() async {
    final userId = _authService.currentUser?.uid;
    _activeUserId = userId;

    if (userId == null) {
      _profile = UserProfile.defaults();
      notifyListeners();
      return;
    }

    _profile = await _repository.loadProfile(userId);
    notifyListeners();
  }


  UserProfile get profile => _profile;
  
  String get name => _profile.name;
  int get age => _profile.age;
  double get weightGoal => _profile.weightGoal;
  String get weightUnit => _profile.weightUnit;
  int get restTimerSeconds => _profile.restTimerSeconds;
  bool get notificationsEnabled => _profile.notificationsEnabled;
  
  bool get isMetric => _profile.isMetric;

  
  Future<void> updateName(String name) async {
    _profile = _profile.copyWith(name: name);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> updateAge(int age) async {
    _profile = _profile.copyWith(age: age);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> updateWeightGoal(double weightGoal) async {
    _profile = _profile.copyWith(weightGoal: weightGoal);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> updateWeightUnit(String unit) async {
    final validUnit = unit == 'lbs' ? 'lbs' : 'kg';
    _profile = _profile.copyWith(weightUnit: validUnit);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> updateRestTimerSeconds(int seconds) async {
    final validSeconds = seconds.clamp(15, 300);
    _profile = _profile.copyWith(restTimerSeconds: validSeconds);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    _profile = _profile.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.saveProfile(_activeUserId!, _profile);
    }
  }

  Future<void> resetProfile() async {
    _profile = UserProfile.defaults();
    notifyListeners();
    if (_activeUserId != null) {
      await _repository.clearProfile(_activeUserId!);
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
