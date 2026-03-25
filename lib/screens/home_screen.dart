import 'package:fitness_tracker_app/widgets/app_header.dart';
import 'package:fitness_tracker_app/widgets/featured_workout_card.dart';
import 'package:fitness_tracker_app/widgets/welcome_greeting.dart';
import 'package:fitness_tracker_app/widgets/workouts_section_header.dart';
import 'package:fitness_tracker_app/widgets/responsive_workouts_grid.dart';
import 'package:fitness_tracker_app/app_router.dart';
import 'package:fitness_tracker_app/providers/profile_provider.dart';
import 'package:fitness_tracker_app/screens/settings_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  Map<String, dynamic>? _lastAddedExercise;

  final Map<String, Color> _categoryThemeColors = {
    'Cardio': Colors.red,
    'Strength Training': Colors.blue,
    'Yoga Flow': Colors.deepPurple,
    'Flexibility': Colors.green,
  };

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
 //this function will open the AddExerciseScreen and wait for the result when the user saves a new exercise. The result will be a Map containing the exercise details, which we will then add to our workouts list and update the UI accordingly.
  Future<void> _openAddExerciseForm() async {
    //the result from the AddExerciseScreen will be a Map<String, dynamic> containing the exercise details
    final exerciseData = await Navigator.of(context).pushRoute<Map<String, dynamic>>(
      AppRoute.addExercise,
    );
//if the user cancels the form, exerciseData will be null
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
    final profileProvider = context.watch<ProfileProvider>();
    final trimmedName = profileProvider.name.trim();
    final isGuest = trimmedName.isEmpty || trimmedName == 'Guest';
    final greetingText = isGuest ? 'Welcome!' : 'Welcome back, $trimmedName!';
    final hasGoal = profileProvider.weightGoal > 0;

    return Scaffold(
      appBar: FitnessAppBar(
        onProfileTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const SettingsProfileScreen(),
            ),
          );
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
            WelcomeGreeting(greetingText: greetingText),
            if (hasGoal) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  'Goal: ${profileProvider.weightGoal.toStringAsFixed(1)} ${profileProvider.weightUnit}',
                ),
              ),
            ],
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
            //the material widget with an InkWell allows us to create a tappable area that looks like a card. When the user taps on it, we navigate to the BMICalculatorScreen. The card has an icon, a title, and a forward arrow to indicate that it's clickable. 
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushRoute(
                    AppRoute.bmiCalculator,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Ink(
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

            const SizedBox(height: 12),

            // Exercise Browse and Routine Summary Buttons
            Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushRoute(
                          AppRoute.exerciseBrowse,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green[200]!, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.shopping_cart_outlined, color: Colors.green[900]),
                            const SizedBox(height: 8),
                            Text(
                              'Browse',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushRoute(
                          AppRoute.routineSummary,
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!, width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.orange[900]),
                            const SizedBox(height: 8),
                            Text(
                              'My Routine',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

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
                onWorkoutTap: (index) {
                  //if the user taps on a workout card that is beyond the first 4 categories, we simply return and do nothing. This is because we only have defined navigation for the first 4 categories (Cardio, Strength Training, Yoga Flow, Flexibility). For any additional workouts that might be added dynamically, we currently do not have a specific screen to navigate to, so we prevent any action from occurring when they are tapped.
                  if (index >= 4) {
                    return;
                  }

                  final categoryName = workouts[index]['name']!;
                  final color = _categoryThemeColors[categoryName] ??
                      Theme.of(context).colorScheme.primary;
                  //when a workout card is tapped, we navigate to the ExerciseListScreen for that category. We pass the category name, theme color, and icon data as arguments to the screen so that it can display the appropriate exercises and styling based on the selected workout category. 
                  Navigator.of(context).pushRouteWithArgs(
                    AppRoute.exerciseList,
                    ExerciseListArgs(
                      categoryName: categoryName,
                      themeColor: color,
                      iconData: workoutIcons[index],
                    ),
                  );
                },
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
