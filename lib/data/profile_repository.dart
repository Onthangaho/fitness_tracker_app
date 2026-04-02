import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  static const String _keyPrefix = 'user_profile';

  String _keyForUser(String userId) => '$_keyPrefix:$userId';

  Future<void> saveProfile(String userId, UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_keyForUser(userId), jsonString);
  }

  Future<UserProfile> loadProfile(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyForUser(userId));

      if (jsonString == null) {
        return UserProfile.defaults();
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      return UserProfile.defaults();
    }
  }

  Future<void> clearProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForUser(userId));
  }
}
