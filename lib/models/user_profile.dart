class UserProfile {
  final String name;
  final int age;
  final double weightGoal;
  final String weightUnit;
  final int restTimerSeconds;
  final bool notificationsEnabled;

  const UserProfile({
    required this.name,
    required this.age,
    required this.weightGoal,
    required this.weightUnit,
    required this.restTimerSeconds,
    required this.notificationsEnabled,
  });

  factory UserProfile.defaults() {
    return const UserProfile(
      name: 'Guest',
      age: 0,
      weightGoal: 0.0,
      weightUnit: 'kg',
      restTimerSeconds: 60,
      notificationsEnabled: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weightGoal': weightGoal,
      'weightUnit': weightUnit,
      'restTimerSeconds': restTimerSeconds,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String validName = 'Guest';
    if (json['name'] is String) {
      final name = (json['name'] as String).trim();
      if (name.isNotEmpty) {
        validName = name;
      }
    }

    int validAge = 0;
    if (json['age'] is int) {
      final age = json['age'] as int;
      if (age >= 0 && age <= 120) {
        validAge = age;
      }
    }

    double validWeightGoal = 0.0;
    if (json['weightGoal'] is num) {
      final goal = (json['weightGoal'] as num).toDouble();
      if (goal >= 0) {
        validWeightGoal = goal;
      }
    }

    String validWeightUnit = 'kg';
    if (json['weightUnit'] is String) {
      final unit = json['weightUnit'] as String;
      if (unit == 'kg' || unit == 'lbs') {
        validWeightUnit = unit;
      }
    }

    int validRestTimer = 60;
    if (json['restTimerSeconds'] is int) {
      final timer = json['restTimerSeconds'] as int;
      validRestTimer = timer.clamp(15, 300);
    }

    bool validNotifications = true;
    if (json['notificationsEnabled'] is bool) {
      validNotifications = json['notificationsEnabled'] as bool;
    }

    return UserProfile(
      name: validName,
      age: validAge,
      weightGoal: validWeightGoal,
      weightUnit: validWeightUnit,
      restTimerSeconds: validRestTimer,
      notificationsEnabled: validNotifications,
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    double? weightGoal,
    String? weightUnit,
    int? restTimerSeconds,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      weightGoal: weightGoal ?? this.weightGoal,
      weightUnit: weightUnit ?? this.weightUnit,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  bool get isDefaultProfile => name == 'Guest' && age == 0 && weightGoal == 0.0;

  bool get isMetric => weightUnit == 'kg';

  @override
  String toString() =>
      'UserProfile(name: $name, age: $age, weightGoal: $weightGoal, weightUnit: $weightUnit, restTimerSeconds: $restTimerSeconds, notificationsEnabled: $notificationsEnabled)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age &&
          weightGoal == other.weightGoal &&
          weightUnit == other.weightUnit &&
          restTimerSeconds == other.restTimerSeconds &&
          notificationsEnabled == other.notificationsEnabled;

  @override
  int get hashCode =>
      name.hashCode ^
      age.hashCode ^
      weightGoal.hashCode ^
      weightUnit.hashCode ^
      restTimerSeconds.hashCode ^
      notificationsEnabled.hashCode;
}
