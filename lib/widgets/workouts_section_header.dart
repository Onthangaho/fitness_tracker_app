import 'package:flutter/material.dart';

class WorkoutsSectionHeader extends StatelessWidget {
  final VoidCallback onViewAllPressed;

  const WorkoutsSectionHeader({super.key, required this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Your Workouts',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: const Text('View All'),
        ),
      ],
    );
  }
}
