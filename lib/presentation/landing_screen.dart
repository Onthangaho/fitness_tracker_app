import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({
    super.key,
    required this.onSignInTap,
    required this.onCreateAccountTap,
  });

  final VoidCallback onSignInTap;
  final VoidCallback onCreateAccountTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE0B2), Color(0xFFFFF8E1), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 76,
                          width: 76,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.deepOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Fitness Tracker',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Build consistency with guided workouts, route tracking, and progress-focused feedback.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            Chip(label: Text('GPS Tracking')),
                            Chip(label: Text('Smart Notifications')),
                            Chip(label: Text('Auth Secured')),
                          ],
                        ),
                        const SizedBox(height: 28),
                        FilledButton(
                          onPressed: onSignInTap,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: onCreateAccountTap,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: const Text('Create Account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
