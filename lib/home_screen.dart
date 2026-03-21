import 'package:fitness_tracker_app/widgets/app_header.dart';
import 'package:fitness_tracker_app/widgets/featured_workout_card.dart';
import 'package:fitness_tracker_app/widgets/welcome_greeting.dart';
import 'package:fitness_tracker_app/widgets/workouts_section_header.dart';
import 'package:fitness_tracker_app/widgets/responsive_workouts_grid.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
 
  final List<Map<String, String>> workouts = [
    {'name': 'Cardio', 'status': 'Completed'},
    {'name': 'Strength Training', 'status': 'In Progress'},
    {'name': 'Yoga Flow', 'status': 'Pending'},
    {'name': 'Flexibility', 'status': 'Pending'},
  ];

 
  final List<IconData> workoutIcons = [
    Icons.directions_run,
    Icons.fitness_center,
    Icons.self_improvement,
    Icons.accessibility_new,
  ];

 
  final Set<int> favoriteWorkouts = {};

  
  String? username;

  @override
  Widget build(BuildContext context) {
    
    String displayName = username ?? 'Guest User';

    return Scaffold(
      
      appBar: FitnessAppBar(
       
        onProfileTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile feature coming soon!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },

        
        onNotificationsTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Notifications feature coming soon!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },

        
        notificationCount: '3',
      ),

      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Welcome greeting section
            WelcomeGreeting(displayName: displayName),
            const SizedBox(height: 16),

            /// Featured workout card - highlighted workout for user to start
            FeaturedWorkoutCard(
              title: 'Featured Workout of the Day',
              description: 'High-Intensity Interval Training (HIIT) - Burn calories - 20 mins',
              onStartPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Starting Featured Workout!....'),
                    backgroundColor: Colors.deepOrange,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            
            WorkoutsSectionHeader(
              onViewAllPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('View All Workouts feature coming soon!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),

            const SizedBox(height: 8),
            Expanded(
              child: ResponsiveWorkoutsGrid(
                workouts: workouts,
                workoutIcons: workoutIcons,
                favoriteWorkouts: favoriteWorkouts,
                
                onFavoriteToggle: (index) {
                  setState(() {
                    if (favoriteWorkouts.contains(index)) {
                      // Remove from favorites if already favorited
                      favoriteWorkouts.remove(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Removed from favorites'),
                          backgroundColor: Colors.deepOrange,
                        ),
                      );
                    } else {
                      // Add to favorites
                      favoriteWorkouts.add(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to favorites'),
                          backgroundColor: Colors.deepOrange,
                        ),
                      );
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add Workout feature coming soon!'),
              backgroundColor: Colors.deepOrange,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}