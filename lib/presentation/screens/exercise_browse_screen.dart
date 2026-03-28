import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/routine_provider.dart';
import '../../providers/exercise_provider.dart';

class ExerciseBrowseScreen extends StatelessWidget {
  const ExerciseBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Exercises'),
        centerTitle: true,
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: exerciseProvider.exercises.length,
            itemBuilder: (context, index) {
              final exercise = exerciseProvider.exercises[index];
              return _ExerciseTile(exercise: exercise);
            },
          );
        },
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final dynamic exercise;

  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final isInRoutine = routineProvider.isInRoutine(exercise.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      child: ListTile(
        tileColor: isInRoutine ? Colors.grey.withValues(alpha: 0.2) : Colors.white,
        title: Text(
          exercise.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isInRoutine ? Colors.grey[600] : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              exercise.muscleGroup,
              style: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${exercise.sets}×${exercise.reps} @ ${exercise.weight}kg = ${exercise.volume.toStringAsFixed(0)} kg',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: _buildTrailingButton(context, isInRoutine),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildTrailingButton(BuildContext context, bool isInRoutine) {
    if (isInRoutine) {
      return Chip(
        avatar: const Icon(Icons.check_circle, color: Colors.white, size: 18),
        label: const Text('Added', style: TextStyle(color: Colors.white, fontSize: 12)),
        backgroundColor: Colors.green,
      );
    }
    return IconButton(
      icon: const Icon(Icons.add_circle_outline, color: Colors.deepOrange),
      onPressed: () {
        context.read<RoutineProvider>().addExercise(exercise);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${exercise.name} added to routine'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}


