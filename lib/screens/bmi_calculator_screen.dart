import 'package:flutter/material.dart';
import 'package:fitness_tracker_app/widgets/input_card.dart';
import 'package:fitness_tracker_app/widgets/result_display_box.dart';
import 'package:fitness_tracker_app/widgets/custom_inkwell_button.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  double? _bmiValue;
  BMICategory? _bmiCategory;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter valid height and weight values'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);

    BMICategory category;
    if (bmi < 18.5) {
      category = BMICategory.underweight;
    } else if (bmi < 25) {
      category = BMICategory.normal;
    } else if (bmi < 30) {
      category = BMICategory.overweight;
    } else {
      category = BMICategory.obese;
    }

    setState(() {
      _bmiValue = bmi;
      _bmiCategory = category;
    });
  }

  void _resetCalculator() {
    setState(() {
      _heightController.clear();
      _weightController.clear();
      _bmiValue = null;
      _bmiCategory = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculator reset'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange[900],
        foregroundColor: Colors.white,
        title: const Text('BMI Calculator', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your height and weight',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            InputCard(
              label: 'Height',
              unit: 'cm',
              icon: Icons.height,
              controller: _heightController,
              hintText: 'Enter height in centimeters',
            ),
            const SizedBox(height: 16),
            InputCard(
              label: 'Weight',
              unit: 'kg',
              icon: Icons.scale,
              controller: _weightController,
              hintText: 'Enter weight in kilograms',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomInkWellButton(
                    label: 'Calculate BMI',
                    onPressed: _calculateBMI,
                    backgroundColor: Colors.deepOrange,
                    textColor: Colors.white,
                    icon: Icons.calculate,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInkWellButton(
                    label: 'Reset',
                    onPressed: _resetCalculator,
                    backgroundColor: Colors.transparent,
                    textColor: Colors.deepOrange,
                    icon: Icons.refresh,
                    height: 50,
                    border: Border.all(color: Colors.deepOrange, width: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ResultDisplayBox(
              bmiValue: _bmiValue,
              category: _bmiCategory,
            ),
            const SizedBox(height: 24),
            Text(
              'BMI = weight (kg) / height (m)²',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
