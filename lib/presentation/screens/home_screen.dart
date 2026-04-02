import '../widgets/app_header.dart';
import '../widgets/featured_workout_card.dart';
import '../widgets/welcome_greeting.dart';
import '../widgets/workouts_section_header.dart';
import '../widgets/responsive_workouts_grid.dart';
import '../app_router.dart';
import '../../domain/auth_provider.dart';
import '../../providers/profile_provider.dart';
import './settings_profile_screen.dart';
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
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _toggleFavoriteWorkout(int index) {
    setState(() {
      if (favoriteWorkouts.contains(index)) {
        favoriteWorkouts.remove(index);
        _showSnackBar(
          'Removed from favorites',
          backgroundColor: Colors.deepOrange,
        );
      } else {
        favoriteWorkouts.add(index);
        _showSnackBar('Added to favorites', backgroundColor: Colors.deepOrange);
      }
    });
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out?'),
          content: const Text(
            'You will be logged out and sent to the landing page.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (shouldSignOut != true || !mounted) {
      return;
    }

    await context.read<AuthProvider>().logout();
  }

  Future<void> _openAddExerciseForm() async {
    final exerciseData = await Navigator.of(
      context,
    ).pushRoute<Map<String, dynamic>>(AppRoute.addExercise);
    if (exerciseData == null) {
      return;
    }

    final String name = (exerciseData['name'] as String?) ?? 'Custom Exercise';
    final int sets = (exerciseData['sets'] as int?) ?? 0;
    final int reps = (exerciseData['reps'] as int?) ?? 0;
    final double weight = (exerciseData['weight'] as double?) ?? 0;
    final String muscleGroup =
        (exerciseData['muscleGroup'] as String?) ?? 'General';

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

    _showSnackBar(
      '$name saved successfully',
      backgroundColor: Colors.green[700],
    );
  }

  Widget _metricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12)),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.watch<AuthProvider>();
    final userEmail = authProvider.userEmail;
    final emailPrefix = userEmail == null
      ? ''
      : userEmail.split('@').first.trim();
    final greetingText =
      emailPrefix.isEmpty ? 'Welcome!' : 'Welcome, $emailPrefix!';
    final hasGoal = profileProvider.weightGoal > 0;

    return Scaffold(
      appBar: FitnessAppBar(
        onProfileTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsProfileScreen()),
          );
        },
        onLogoutTap: _confirmSignOut,

        onNotificationsTap: () {
          _showSnackBar('Notifications feature coming soon!');
        },

        notificationCount: '3',
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8F2), Color(0xFFFFFFFF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeGreeting(greetingText: greetingText),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _metricTile(
                        icon: Icons.flag_outlined,
                        label: 'Goal',
                        value: hasGoal
                            ? '${profileProvider.weightGoal.toStringAsFixed(1)} ${profileProvider.weightUnit}'
                            : 'Not set',
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _metricTile(
                        icon: Icons.favorite_border,
                        label: 'Favorites',
                        value: favoriteWorkouts.length.toString(),
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                FeaturedWorkoutCard(
                  title: 'Featured Workout of the Day',
                  description:
                      'High-Intensity Interval Training (HIIT) - Burn calories - 20 mins',
                  onStartPressed: () {
                    _showSnackBar(
                      'Starting Featured Workout!....',
                      backgroundColor: Colors.deepOrange,
                    );
                  },
                ),

                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushRoute(AppRoute.bmiCalculator);
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                      ],
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 12),

                Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushRoute(AppRoute.outdoorWorkout);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Ink(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal[200]!, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.route, color: Colors.teal[900]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Outdoor Workout (GPS)',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.teal[700],
                        ),
                      ],
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 12),

                Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushRoute(AppRoute.exerciseBrowse);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.green[900],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Browse',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                          Navigator.of(
                            context,
                          ).pushRoute(AppRoute.exerciseSearch);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.purple[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.public, color: Colors.purple[900]),
                              const SizedBox(height: 8),
                              Text(
                                'API Search',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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
                          Navigator.of(
                            context,
                          ).pushRoute(AppRoute.routineSummary);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange[200]!,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.orange[900],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'My Routine',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
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

                ResponsiveWorkoutsGrid(
                  workouts: workouts,
                  workoutIcons: workoutIcons,
                  favoriteWorkouts: favoriteWorkouts,
                  onFavoriteToggle: _toggleFavoriteWorkout,
                  onWorkoutTap: (index) {
                    if (index >= 4) {
                      return;
                    }

                    final categoryName = workouts[index]['name']!;
                    final color =
                        _categoryThemeColors[categoryName] ??
                        Theme.of(context).colorScheme.primary;
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
              ],
            ),
          ),
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
