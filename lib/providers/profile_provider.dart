import 'package:flutter/material.dart';
import '../data/profile_repository.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository;
  
  UserProfile _profile = UserProfile.defaults();

  ProfileProvider(this._repository) {
    _init();
  }

  Future<void> _init() async {
    _profile = await _repository.loadProfile();
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
    await _repository.saveProfile(_profile);
  }

  Future<void> updateAge(int age) async {
    _profile = _profile.copyWith(age: age);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateWeightGoal(double weightGoal) async {
    _profile = _profile.copyWith(weightGoal: weightGoal);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateWeightUnit(String unit) async {
    final validUnit = unit == 'lbs' ? 'lbs' : 'kg';
    _profile = _profile.copyWith(weightUnit: validUnit);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateRestTimerSeconds(int seconds) async {
    final validSeconds = seconds.clamp(15, 300);
    _profile = _profile.copyWith(restTimerSeconds: validSeconds);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    _profile = _profile.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    await _repository.saveProfile(_profile);
  }

  Future<void> resetProfile() async {
    _profile = UserProfile.defaults();
    notifyListeners();
    await _repository.clearProfile();
  }
}
