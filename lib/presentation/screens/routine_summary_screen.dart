import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/routine_provider.dart';
import 'exercise_browse_screen.dart';

class RoutineSummaryScreen extends StatelessWidget {
  const RoutineSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Routine'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[900],
        actions: [
          Consumer<RoutineProvider>(
            builder: (context, routine, _) {
              if (routine.exerciseCount == 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                  label: Text(routine.exerciseCount.toString()),
                  child: const Icon(Icons.fitness_center),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<RoutineProvider>(
        builder: (context, routine, _) {
          if (routine.exerciseCount == 0) {
            return _EmptyState();
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                _StatisticsSection(routine: routine),
                const Divider(height: 24),
                _RoutineList(routine: routine),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _showClearConfirmationDialog(context),
                      child: const Text(
                        'Clear Routine',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Routine?'),
        content: const Text(
          'Are you sure you want to remove all exercises from your routine? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<RoutineProvider>().clearRoutine();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Routine cleared'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your routine is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse exercises and add them to build your routine.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ExerciseBrowseScreen()),
              );
            },
            child: const Text('Browse Exercises'),
          ),
        ],
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  final RoutineProvider routine;

  const _StatisticsSection({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Routine Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildStatsGrid(),
          const SizedBox(height: 16),
          _buildMuscleGroupBreakdown(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatCard(label: 'Exercises', value: routine.exerciseCount.toString(), color: Colors.blue),
        _StatCard(label: 'Total Sets', value: routine.totalSets.toString(), color: Colors.orange),
        _StatCard(label: 'Total Volume', value: '${routine.totalVolume.toStringAsFixed(0)} kg', color: Colors.green),
      ],
    );
  }

  Widget _buildMuscleGroupBreakdown() {
    final breakdown = routine.muscleGroupBreakdown;
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Muscle Group Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: breakdown.entries
              .map((entry) => Chip(
                    label: Text('${entry.key} (${entry.value})'),
                    backgroundColor: Colors.deepOrange.withValues(alpha: 0.2),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _RoutineList extends StatelessWidget {
  final RoutineProvider routine;

  const _RoutineList({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Exercises', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: routine.routine.length,
            itemBuilder: (context, index) => _ExerciseItem(exercise: routine.routine[index]),
          ),
        ],
      ),
    );
  }
}

class _ExerciseItem extends StatelessWidget {
  final dynamic exercise;

  const _ExerciseItem({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(exercise.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<RoutineProvider>().removeExercise(exercise.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${exercise.name} removed'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange,
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 1,
        child: ListTile(
          title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                exercise.muscleGroup,
                style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                '${exercise.sets}×${exercise.reps} @ ${exercise.weight}kg = ${exercise.volume.toStringAsFixed(0)} kg',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              context.read<RoutineProvider>().removeExercise(exercise.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${exercise.name} removed'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


