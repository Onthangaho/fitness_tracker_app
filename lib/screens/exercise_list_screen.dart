import 'package:fitness_tracker_app/app_router.dart';
import 'package:flutter/material.dart';

class ExerciseListScreen extends StatelessWidget {
  final String categoryName;
  final Color themeColor;
  final IconData iconData;

  const ExerciseListScreen({
    super.key,
    required this.categoryName,
    required this.themeColor,
    required this.iconData,
  });
 // This method returns a list of ExerciseDetailArgs based on the category name. It checks the category name against known categories (Cardio, Strength Training, Yoga/Flexibility) and returns a predefined list of exercises for each category. If the category does not match any of the known categories, it returns a default list of general exercises. Each ExerciseDetailArgs contains details about an exercise, such as its name, muscle group, sets, reps, and weight.
  List<ExerciseDetailArgs> _exercisesForCategory(String category) {
    final normalized = category.toLowerCase();

    if (normalized.contains('cardio')) {
      return const [
        ExerciseDetailArgs(
          exerciseName: 'Running',
          muscleGroup: 'Legs',
          sets: 1,
          reps: 30,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Jump Rope',
          muscleGroup: 'Full Body',
          sets: 4,
          reps: 120,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Cycling',
          muscleGroup: 'Legs',
          sets: 3,
          reps: 20,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Burpees',
          muscleGroup: 'Full Body',
          sets: 4,
          reps: 15,
          weight: 0,
        ),
      ];
    }

    if (normalized.contains('strength')) {
      return const [
        ExerciseDetailArgs(
          exerciseName: 'Bench Press',
          muscleGroup: 'Chest',
          sets: 4,
          reps: 8,
          weight: 60,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Deadlift',
          muscleGroup: 'Back',
          sets: 5,
          reps: 5,
          weight: 100,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Barbell Squat',
          muscleGroup: 'Legs',
          sets: 4,
          reps: 6,
          weight: 80,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Shoulder Press',
          muscleGroup: 'Shoulders',
          sets: 3,
          reps: 10,
          weight: 35,
        ),
      ];
    }

    if (normalized.contains('yoga') || normalized.contains('flexibility')) {
      return const [
        ExerciseDetailArgs(
          exerciseName: 'Hamstring Stretch',
          muscleGroup: 'Hamstrings',
          sets: 3,
          reps: 30,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Hip Flexor Stretch',
          muscleGroup: 'Hip Flexors',
          sets: 3,
          reps: 30,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Cat-Cow Flow',
          muscleGroup: 'Core',
          sets: 4,
          reps: 12,
          weight: 0,
        ),
        ExerciseDetailArgs(
          exerciseName: 'Child\'s Pose',
          muscleGroup: 'Lower Back',
          sets: 3,
          reps: 45,
          weight: 0,
        ),
      ];
    }

    return const [
      ExerciseDetailArgs(
        exerciseName: 'Bodyweight Squat',
        muscleGroup: 'Legs',
        sets: 3,
        reps: 12,
        weight: 0,
      ),
      ExerciseDetailArgs(
        exerciseName: 'Push-up',
        muscleGroup: 'Chest',
        sets: 3,
        reps: 10,
        weight: 0,
      ),
      ExerciseDetailArgs(
        exerciseName: 'Plank',
        muscleGroup: 'Core',
        sets: 3,
        reps: 60,
        weight: 0,
      ),
      ExerciseDetailArgs(
        exerciseName: 'Lunges',
        muscleGroup: 'Legs',
        sets: 3,
        reps: 12,
        weight: 0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _exercisesForCategory(categoryName);
    final brightness = ThemeData.estimateBrightnessForColor(themeColor);
    final foregroundColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Exercises'),
        backgroundColor: Colors.deepOrange[900],
        foregroundColor: foregroundColor,
        leading: IconButton(
          tooltip: 'Go Back',
            icon: Icon(Icons.navigate_before,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            Icon(iconData, color: foregroundColor),
            const SizedBox(width: 16),
          ],
      
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final exercise = exercises[index];

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(exercise.exerciseName),
              subtitle: Text(
                '${exercise.muscleGroup} • ${exercise.sets} sets × ${exercise.reps} reps',
              ),
              trailing: const Icon(Icons.chevron_right),
              // When a user taps on an exercise card, we navigate to the ExerciseDetailScreen for that specific exercise. We pass the exercise details (name, muscle group, sets, reps, weight) as arguments to the screen so that it can display the appropriate information about the selected exercise.
              onTap: () {
                Navigator.of(context).pushRouteWithArgs(
                  AppRoute.exerciseDetail,
                  exercise,
                );
              },
            ),
          );
        },
      ),
    );
  }
}