import './workout_tile.dart';
import 'package:flutter/material.dart';

class ResponsiveWorkoutsGrid extends StatelessWidget {
  final List<Map<String, String>> workouts;
  final List<IconData> workoutIcons;
  final Set<int> favoriteWorkouts;
  final Function(int) onFavoriteToggle;
  final Function(int)? onWorkoutTap;

  const ResponsiveWorkoutsGrid({
    super.key,
    required this.workouts,
    required this.workoutIcons,
    required this.favoriteWorkouts,
    required this.onFavoriteToggle,
    this.onWorkoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: workouts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            final workout = workouts[index];

            return WorkoutTile(
              workoutName: workout['name']!,
              icon: workoutIcons[index],
              status: workout['status']!,
              isFavorite: favoriteWorkouts.contains(index),
              onFavoriteToggle: () {
                onFavoriteToggle(index);
              },
              onTap: onWorkoutTap == null
                  ? null
                  : () {
                      onWorkoutTap!(index);
                    },
            );
          },
        );
      },
    );
  }
}
