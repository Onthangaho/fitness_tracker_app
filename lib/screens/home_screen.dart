import 'package:fitness_tracker_app/widgets/app_header.dart';
import 'package:fitness_tracker_app/widgets/featured_workout_card.dart';
import 'package:fitness_tracker_app/widgets/welcome_greeting.dart';
import 'package:fitness_tracker_app/widgets/workouts_section_header.dart';
import 'package:fitness_tracker_app/widgets/responsive_workouts_grid.dart';
import 'package:fitness_tracker_app/screens/bmi_calculator_screen.dart';
import 'package:fitness_tracker_app/screens/add_exercise_screen.dart';
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
  Map<String, dynamic>? _lastAddedExercise;

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _toggleFavoriteWorkout(int index) {
    setState(() {
      if (favoriteWorkouts.contains(index)) {
        favoriteWorkouts.remove(index);
        _showSnackBar('Removed from favorites', backgroundColor: Colors.deepOrange);
      } else {
        favoriteWorkouts.add(index);
        _showSnackBar('Added to favorites', backgroundColor: Colors.deepOrange);
      }
    });
  }

  Future<void> _openAddExerciseForm() async {
    final exerciseData = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExerciseScreen(),
      ),
    );

    if (exerciseData == null) {
      return;
    }

    final String name = (exerciseData['name'] as String?) ?? 'Custom Exercise';
    final int sets = (exerciseData['sets'] as int?) ?? 0;
    final int reps = (exerciseData['reps'] as int?) ?? 0;
    final double weight = (exerciseData['weight'] as double?) ?? 0;
    final String muscleGroup = (exerciseData['muscleGroup'] as String?) ?? 'General';

    final String weightText = weight % 1 == 0
        ? weight.toStringAsFixed(0)
        : weight.toStringAsFixed(1);

    setState(() {
      workouts.add({
        'name': name,
        'status': '$sets sets • $reps reps • ${weightText}kg • $muscleGroup',
      });
      workoutIcons.add(Icons.sports_gymnastics);
      _lastAddedExercise = {
        'name': name,
        'sets': sets,
        'reps': reps,
        'weight': weightText,
        'muscleGroup': muscleGroup,
      };
    });

    _showSnackBar('$name saved successfully', backgroundColor: Colors.green[700]);
  }

  @override
  Widget build(BuildContext context) {
    String displayName = username ?? 'Guest User';

    return Scaffold(
      appBar: FitnessAppBar(
        onProfileTap: () {
          _showSnackBar('Profile feature coming soon!');
        },

        onNotificationsTap: () {
          _showSnackBar('Notifications feature coming soon!');
        },

        notificationCount: '3',
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeGreeting(displayName: displayName),
            const SizedBox(height: 16),

            FeaturedWorkoutCard(
              title: 'Featured Workout of the Day',
              description: 'High-Intensity Interval Training (HIIT) - Burn calories - 20 mins',
              onStartPressed: () {
                _showSnackBar(
                  'Starting Featured Workout!....',
                  backgroundColor: Colors.deepOrange,
                );
              },
            ),

            const SizedBox(height: 24),
           
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BMICalculatorScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calculate, color: Colors.blue[900]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'BMI Calculator',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[700]),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (_lastAddedExercise != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Added Exercise',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_lastAddedExercise!['name']} • ${_lastAddedExercise!['muscleGroup']}',
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_lastAddedExercise!['sets']} sets × ${_lastAddedExercise!['reps']} reps × ${_lastAddedExercise!['weight']}kg',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            WorkoutsSectionHeader(
              onViewAllPressed: () {
                _showSnackBar('View All Workouts feature coming soon!');
              },
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ResponsiveWorkoutsGrid(
                workouts: workouts,
                workoutIcons: workoutIcons,
                favoriteWorkouts: favoriteWorkouts,
                onFavoriteToggle: _toggleFavoriteWorkout,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Exercise',
        onPressed: _openAddExerciseForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
