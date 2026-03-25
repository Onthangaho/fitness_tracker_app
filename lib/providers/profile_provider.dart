import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _profileNameKey = 'profile_name';
  static const String _profileAgeKey = 'profile_age';
  static const String _profileWeightGoalKey = 'profile_weight_goal';
  static const String _prefWeightUnitKey = 'pref_weight_unit';
  static const String _prefRestTimerKey = 'pref_rest_timer';
  static const String _prefNotificationsKey = 'pref_notifications';

  String _name = 'Guest';
  int _age = 0;
  double _weightGoal = 0.0;
  String _weightUnit = 'kg';
  int _restTimerSeconds = 60;
  bool _notificationsEnabled = true;

  ProfileProvider() {
    _loadAll();
  }

  String get name => _name;
  int get age => _age;
  double get weightGoal => _weightGoal;
  String get weightUnit => _weightUnit;
  int get restTimerSeconds => _restTimerSeconds;
  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> saveName(String name) async {
    _name = name.trim().isEmpty ? 'Guest' : name.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileNameKey, _name);
  }

  Future<void> saveAge(int age) async {
    _age = age;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_profileAgeKey, _age);
  }

  Future<void> saveWeightGoal(double weightGoal) async {
    _weightGoal = weightGoal;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_profileWeightGoalKey, _weightGoal);
  }

  Future<void> saveWeightUnit(String weightUnit) async {
    _weightUnit = weightUnit == 'lbs' ? 'lbs' : 'kg';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefWeightUnitKey, _weightUnit);
  }

  Future<void> saveRestTimerSeconds(int restTimerSeconds) async {
    _restTimerSeconds = restTimerSeconds.clamp(15, 300);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefRestTimerKey, _restTimerSeconds);
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefNotificationsKey, _notificationsEnabled);
  }

  Future<void> resetProfile() async {
    _name = 'Guest';
    _age = 0;
    _weightGoal = 0.0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileNameKey);
    await prefs.remove(_profileAgeKey);
    await prefs.remove(_profileWeightGoalKey);
  }

  Future<void> resetEverything() async {
    _name = 'Guest';
    _age = 0;
    _weightGoal = 0.0;
    _weightUnit = 'kg';
    _restTimerSeconds = 60;
    _notificationsEnabled = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    final storedName = prefs.getString(_profileNameKey);
    final storedAge = prefs.getInt(_profileAgeKey);
    final storedWeightGoal = prefs.getDouble(_profileWeightGoalKey);
    final storedWeightUnit = prefs.getString(_prefWeightUnitKey);
    final storedRestTimer = prefs.getInt(_prefRestTimerKey);
    final storedNotifications = prefs.getBool(_prefNotificationsKey);

    _name = (storedName == null || storedName.trim().isEmpty)
        ? 'Guest'
        : storedName.trim();

    final validAge = storedAge ?? 0;
    _age = (validAge < 0 || validAge > 120) ? 0 : validAge;

    final validWeightGoal = storedWeightGoal ?? 0.0;
    _weightGoal = validWeightGoal < 0 ? 0.0 : validWeightGoal;

    _weightUnit = (storedWeightUnit == 'kg' || storedWeightUnit == 'lbs')
        ? storedWeightUnit!
        : 'kg';

    final validRestTimer = (storedRestTimer ?? 60).clamp(15, 300);
    _restTimerSeconds = validRestTimer;

    _notificationsEnabled = storedNotifications ?? true;

    notifyListeners();
  }
}