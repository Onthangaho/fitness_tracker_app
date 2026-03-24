class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
  });

  /// Computed property: total volume (sets × reps × weight)
  double get volume => sets * reps * weight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Exercise(id: $id, name: $name, muscleGroup: $muscleGroup, sets: $sets, reps: $reps, weight: $weight)';
}