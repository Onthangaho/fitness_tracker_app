import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  final String workoutName;
  final String status;
  final IconData icon;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const WorkoutTile({
    super.key,
    required this.workoutName,
    required this.status,
    required this.icon,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, size: 32, color: colorScheme.primary),
                      IconButton(
                        onPressed: onFavoriteToggle,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : colorScheme.onSurfaceVariant,
                        ),
                        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workoutName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}