import 'package:fitness_tracker_app/workout_tile.dart';
import 'package:flutter/material.dart';

/// A responsive grid widget that displays workouts with adaptive layout
/// 
/// This widget handles:
/// - Responsive column count based on screen width
/// - Gesture interaction (favorites toggling)
/// - Workout tile rendering with proper spacing
/// - LayoutBuilder for responsive design
/// 
/// The grid adapts as follows:
/// - Mobile (< 600px): 1 column
/// - Tablet (600-900px): 2 columns
/// - Desktop (> 900px): 3 columns
class ResponsiveWorkoutsGrid extends StatelessWidget {
  /// List of workout data containing name and status
  /// Should be parallel with [workoutIcons] (same length and order)
  final List<Map<String, String>> workouts;

  /// List of icons corresponding to each workout
  /// Index should match workouts list
  final List<IconData> workoutIcons;

  /// Set of indices indicating which workouts are marked as favorites
  /// Used to show filled/outline heart icons
  final Set<int> favoriteWorkouts;

  /// Callback function triggered when a workout's favorite button is tapped
  /// Receives the index of the workout that was toggled
  final Function(int) onFavoriteToggle;

  const ResponsiveWorkoutsGrid({
    super.key,
    required this.workouts,
    required this.workoutIcons,
    required this.favoriteWorkouts,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    /// Determines grid columns based on available screen width
    /// Uses LayoutBuilder to get dynamic constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid layout based on available width
        int crossAxisCount;

        // For mobile phones (< 600px): 1 column
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        }
        // For tablets (600-900px): 2 columns
        else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }
        // For large screens (> 900px): 3 columns
        else {
          crossAxisCount = 3;
        }

        /// Build the responsive grid with adaptive columns
        return GridView.builder(
          // Total number of workouts to display
          itemCount: workouts.length,

          // Configure grid layout with fixed number of columns
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            // Horizontal spacing between tiles
            crossAxisSpacing: 16,
            // Vertical spacing between tiles
            mainAxisSpacing: 16,
            // Aspect ratio (width / height) of each tile
            childAspectRatio: 1.5,
          ),

          /// Build individual workout tiles
          itemBuilder: (context, index) {
            final workout = workouts[index];

            return WorkoutTile(
              workoutName: workout['name']!,
              icon: workoutIcons[index],
              status: workout['status']!,
              isFavorite: favoriteWorkouts.contains(index),

              /// Handle favorite button toggle by calling the callback
              onFavoriteToggle: () {
                onFavoriteToggle(index);
              },
            );
          },
        );
      },
    );
  }
}
