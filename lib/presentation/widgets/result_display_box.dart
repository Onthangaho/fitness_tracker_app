import 'package:flutter/material.dart';

enum BMICategory {
  underweight,
  normal,
  overweight,
  obese,
}

extension BMICategoryExtension on BMICategory {
  String get label {
    switch (this) {
      case BMICategory.underweight:
        return 'Underweight';
      case BMICategory.normal:
        return 'Normal Weight';
      case BMICategory.overweight:
        return 'Overweight';
      case BMICategory.obese:
        return 'Obese';
    }
  }

  Color get color {
    switch (this) {
      case BMICategory.underweight:
        return Colors.blue;
      case BMICategory.normal:
        return Colors.green;
      case BMICategory.overweight:
        return Colors.orange;
      case BMICategory.obese:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case BMICategory.underweight:
        return Icons.trending_down;
      case BMICategory.normal:
        return Icons.favorite;
      case BMICategory.overweight:
        return Icons.trending_up;
      case BMICategory.obese:
        return Icons.warning;
    }
  }

  String get advice {
    switch (this) {
      case BMICategory.underweight:
        return 'Eat more nutritious food and focus on strength training';
      case BMICategory.normal:
        return 'Great! Keep maintaining your healthy weight';
      case BMICategory.overweight:
        return 'Consider increasing daily activity and reviewing diet';
      case BMICategory.obese:
        return 'Consult a healthcare provider for personalized advice';
    }
  }
}

class ResultDisplayBox extends StatelessWidget {
  final double? bmiValue;
  final BMICategory? category;

  const ResultDisplayBox({
    super.key,
    required this.bmiValue,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (bmiValue == null || category == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'Enter your height and weight to calculate BMI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    final categoryData = category!;
    final categoryColor = categoryData.color;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: categoryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: categoryColor.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(categoryData.icon, color: categoryColor, size: 28),
              const SizedBox(width: 10),
              Text(
                categoryData.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: categoryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Your BMI: ${bmiValue!.toStringAsFixed(1)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            categoryData.advice,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

