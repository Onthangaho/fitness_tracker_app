import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../domain/workout_tracking_provider.dart';

class OutdoorWorkoutScreen extends StatelessWidget {
  const OutdoorWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outdoor Workout'),
        backgroundColor: Colors.deepOrange[900],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Consumer<WorkoutTrackingProvider>(
          builder: (context, provider, _) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = math.min(constraints.maxWidth, 680.0);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: contentWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (provider.isLoadingLocation) ...[
                            const LinearProgressIndicator(),
                            const SizedBox(height: 12),
                          ],
                          switch (provider.workoutPhase) {
                            WorkoutPhase.idle => _IdlePhase(provider: provider),
                            WorkoutPhase.active => _ActivePhase(
                              provider: provider,
                            ),
                            WorkoutPhase.finished => _FinishedPhase(
                              provider: provider,
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _IdlePhase extends StatelessWidget {
  const _IdlePhase({required this.provider});

  final WorkoutTrackingProvider provider;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.run_circle_outlined, size: 100),
            const SizedBox(height: 16),
            Text(
              'Track your outdoor run with GPS',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Start your workout, keep moving, and finish to see your time, distance, pace, and route summary.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (provider.errorMessage != null) ...[
              Text(
                provider.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: provider.isLoadingLocation
                  ? null
                  : () => provider.startWorkout(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
              ),
              child: provider.isLoadingLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Start Run'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivePhase extends StatelessWidget {
  const _ActivePhase({required this.provider});

  final WorkoutTrackingProvider provider;

  @override
  Widget build(BuildContext context) {
    final current = provider.currentPosition;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Workout in Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  provider.formattedTime,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Coordinates',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  current == null
                      ? 'Waiting for location...'
                      : 'Lat: ${current.latitude.toStringAsFixed(5)} | Lon: ${current.longitude.toStringAsFixed(5)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${provider.routePoints.length} GPS points recorded',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: provider.isLoadingLocation
              ? null
              : () => provider.updateLocation(),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('Update Location'),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: !provider.canFinish || provider.isLoadingLocation
              ? null
              : () => provider.finishWorkout(),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(54),
            backgroundColor: Colors.red.shade600,
          ),
          child: const Text('Finish Run'),
        ),
      ],
    );
  }
}

class _FinishedPhase extends StatelessWidget {
  const _FinishedPhase({required this.provider});

  final WorkoutTrackingProvider provider;

  @override
  Widget build(BuildContext context) {
    final start = provider.startPosition;
    final end = provider.endPosition;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Summary',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 14),
                _SummaryRow(label: 'Total Time', value: provider.formattedTime),
                _SummaryRow(
                  label: 'Straight-line distance',
                  value: provider.formattedDistance,
                ),
                _SummaryRow(
                  label: 'Route distance',
                  value: provider.formattedRouteDistance,
                ),
                _SummaryRow(
                  label: 'Average Pace',
                  value: provider.formattedPace,
                ),
                _SummaryRow(
                  label: 'GPS points recorded',
                  value: '${provider.routePoints.length}',
                ),
                const Divider(height: 28),
                Text(
                  'Start Location',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  _formatPosition(start),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'End Location',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  _formatPosition(end),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route Preview',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: RoutePainter(points: provider.routePoints),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (provider.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            provider.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => provider.resetWorkout(),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: const Text('New Workout'),
        ),
      ],
    );
  }

  String _formatPosition(Position? position) {
    if (position == null) {
      return '--';
    }

    return 'Lat: ${position.latitude.toStringAsFixed(5)}, Lon: ${position.longitude.toStringAsFixed(5)}';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class RoutePainter extends CustomPainter {
  RoutePainter({required this.points});

  final List<Position> points;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.grey.shade100;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      backgroundPaint,
    );

    if (points.length < 2) {
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'Not enough route points yet',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width - 20);

      textPainter.paint(
        canvas,
        Offset(
          (size.width - textPainter.width) / 2,
          (size.height - textPainter.height) / 2,
        ),
      );
      return;
    }

    const padding = 16.0;
    final drawableWidth = size.width - (padding * 2);
    final drawableHeight = size.height - (padding * 2);

    final minLat = points.map((p) => p.latitude).reduce(math.min);
    final maxLat = points.map((p) => p.latitude).reduce(math.max);
    final minLon = points.map((p) => p.longitude).reduce(math.min);
    final maxLon = points.map((p) => p.longitude).reduce(math.max);

    final latRange = (maxLat - minLat).abs() < 0.0000001
        ? 0.0000001
        : (maxLat - minLat);
    final lonRange = (maxLon - minLon).abs() < 0.0000001
        ? 0.0000001
        : (maxLon - minLon);

    Offset normalize(Position point) {
      final normalizedX = (point.longitude - minLon) / lonRange;
      final normalizedY = (point.latitude - minLat) / latRange;
      return Offset(
        padding + (normalizedX * drawableWidth),
        size.height - padding - (normalizedY * drawableHeight),
      );
    }

    final routePath = Path();
    final firstPoint = normalize(points.first);
    routePath.moveTo(firstPoint.dx, firstPoint.dy);

    for (var i = 1; i < points.length; i++) {
      final offset = normalize(points[i]);
      routePath.lineTo(offset.dx, offset.dy);
    }

    final routePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.blue.shade700;

    canvas.drawPath(routePath, routePaint);

    final startMarkerPaint = Paint()..color = Colors.green.shade700;
    final endMarkerPaint = Paint()..color = Colors.red.shade700;

    canvas.drawCircle(normalize(points.first), 5, startMarkerPaint);
    canvas.drawCircle(normalize(points.last), 5, endMarkerPaint);
  }

  @override
  bool shouldRepaint(covariant RoutePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
