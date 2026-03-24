class Exercise{

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

  double get totalVolume => sets * reps * weight;

  @override
 bool operator ==(Object other) {
    if (identical(this, other)) return true;
    //
    return other is Exercise &&
        other.id == id &&
        other.name == name &&
        other.muscleGroup == muscleGroup &&
        other.sets == sets &&
        other.reps == reps &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        muscleGroup.hashCode ^
        sets.hashCode ^
        reps.hashCode ^
        weight.hashCode;
  }  

}