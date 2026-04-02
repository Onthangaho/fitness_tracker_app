import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();

  factory NotificationService() {
    return _instance;
  }

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const String _lastWorkoutDayKey = 'last_workout_day';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized || kIsWeb) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _isInitialized = true;
  }

  Future<void> showWorkoutCompleteAlert({
    required String workoutName,
    required String stats,
    double? distanceKm,
    int? durationSeconds,
    bool? isFirstWorkoutOfDay,
  }) async {
    if (kIsWeb) {
      return;
    }

    final resolvedFirstWorkout =
        isFirstWorkoutOfDay ?? await _isFirstWorkoutToday();

    final title = _resolveWorkoutTitle(
      isFirstWorkoutOfDay: resolvedFirstWorkout,
      distanceKm: distanceKm,
    );

    final body = _buildWorkoutBody(
      workoutName: workoutName,
      stats: stats,
      distanceKm: distanceKm,
      durationSeconds: durationSeconds,
    );

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'workout_complete',
        'Workout Completion',
        channelDescription: 'High-priority workout completion updates',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  Future<void> showReminderNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) {
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'reminders',
        'Reminders',
        channelDescription: 'General reminder notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  String _resolveWorkoutTitle({
    required bool isFirstWorkoutOfDay,
    required double? distanceKm,
  }) {
    if (isFirstWorkoutOfDay) {
      return 'First Workout Done!';
    }

    if (distanceKm != null && distanceKm > 0) {
      return 'Workout Complete!';
    }

    return 'Workout Complete!';
  }

  String _buildWorkoutBody({
    required String workoutName,
    required String stats,
    required double? distanceKm,
    required int? durationSeconds,
  }) {
    final minutes = durationSeconds == null ? 0 : durationSeconds ~/ 60;
    final safeDistance = distanceKm ?? 0;

    if (safeDistance > 5) {
      return 'Amazing endurance! You covered ${safeDistance.toStringAsFixed(1)} km in $stats';
    }

    if (safeDistance > 2) {
      return 'Solid run! ${safeDistance.toStringAsFixed(1)} km completed. $stats';
    }

    if (safeDistance > 0) {
      return 'Every step counts! You ran ${safeDistance.toStringAsFixed(1)} km today. $stats';
    }

    if (minutes > 30) {
      return '30+ minutes of work! $workoutName is done. $stats';
    }

    return '$workoutName complete! Keep the streak alive. $stats';
  }

  Future<bool> _isFirstWorkoutToday() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final lastWorkoutDay = prefs.getString(_lastWorkoutDayKey);
    if (lastWorkoutDay == today) {
      return false;
    }

    await prefs.setString(_lastWorkoutDayKey, today);
    return true;
  }
}
