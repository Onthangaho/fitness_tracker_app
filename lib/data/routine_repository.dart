import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_model.dart';

class RoutineRepository {
  static const String _keyPrefix = 'user_routine';

  String _keyForUser(String userId) => '$_keyPrefix:$userId';

  Future<void> saveRoutine(String userId, List<Exercise> routine) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = routine.map((exercise) => exercise.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_keyForUser(userId), jsonString);
  }

  Future<List<Exercise>> loadRoutine(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyForUser(userId));

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Exercise.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearRoutine(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForUser(userId));
  }
}
