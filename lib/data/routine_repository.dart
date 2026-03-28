import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercise_model.dart';

class RoutineRepository {
  static const String _key = 'user_routine';

  Future<void> saveRoutine(List<Exercise> routine) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = routine.map((exercise) => exercise.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_key, jsonString);
  }

  Future<List<Exercise>> loadRoutine() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);

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

  Future<void> clearRoutine() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
