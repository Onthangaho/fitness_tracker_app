import 'package:flutter/material.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  // Form key to manage form state and validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _exerciseNameController;
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _weightController;

  String? _selectedMuscleGroup;

  static const List<String> _muscleGroups = [
    'Chest',
    'Back',
    'Legs',
    'Arms',
    'Shoulders',
    'Core',
  ];

  @override
  void initState() {
    super.initState();
    _exerciseNameController = TextEditingController();
    _setsController = TextEditingController();
    _repsController = TextEditingController();
    _weightController = TextEditingController();

    _setsController.addListener(_onVolumeInputChanged);
    _repsController.addListener(_onVolumeInputChanged);
    _weightController.addListener(_onVolumeInputChanged);
  }

  @override
  void dispose() {
    _setsController.removeListener(_onVolumeInputChanged);
    _repsController.removeListener(_onVolumeInputChanged);
    _weightController.removeListener(_onVolumeInputChanged);

    _exerciseNameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }
// Recalculate volume preview whenever sets, reps, or weight input changes
  void _onVolumeInputChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  InputDecoration _fieldDecoration({
    required String labelText,
    String? hintText,
    required IconData icon,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixText: suffixText,
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String? _validateExerciseName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Exercise name is required';
    }
    if (name.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (name.length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    return null;
  }

  String? _validateSets(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Number of sets is required';
    }
    final parsed = int.tryParse(input);
    if (parsed == null) {
      return 'Sets must be a whole number';
    }
    if (parsed <= 0) {
      return 'Sets must be greater than zero';
    }
    if (parsed > 20) {
      return 'Sets cannot exceed 20';
    }
    return null;
  }

  String? _validateReps(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Number of reps is required';
    }
    final parsed = int.tryParse(input);
    if (parsed == null) {
      return 'Reps must be a whole number';
    }
    if (parsed <= 0) {
      return 'Reps must be greater than zero';
    }
    if (parsed > 100) {
      return 'Reps cannot exceed 100';
    }
    return null;
  }

  String? _validateWeight(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Weight is required';
    }
    final parsed = double.tryParse(input);
    if (parsed == null) {
      return 'Weight must be a valid number';
    }
    if (parsed < 0) {
      return 'Weight cannot be negative';
    }
    if (parsed > 500) {
      return 'Weight cannot exceed 500kg';
    }
    return null;
  }

  int? get _previewSets => int.tryParse(_setsController.text.trim());
  int? get _previewReps => int.tryParse(_repsController.text.trim());
  double? get _previewWeight => double.tryParse(_weightController.text.trim());

  String get _volumePreview {
    final sets = _previewSets;
    final reps = _previewReps;
    final weight = _previewWeight;

    final setsText = sets?.toString() ?? '--';
    final repsText = reps?.toString() ?? '--';
    final weightText = weight == null
        ? '--'
        : (weight % 1 == 0 ? weight.toStringAsFixed(0) : weight.toStringAsFixed(1));

    if (sets == null || reps == null || weight == null) {
      return 'Total Volume: $setsText × $repsText × $weightText = -- kg';
    }

    final result = sets * reps * weight;
    final resultText = result % 1 == 0 ? result.toStringAsFixed(0) : result.toStringAsFixed(1);

    return 'Total Volume: $setsText × $repsText × $weightText = $resultText kg';
  }
 // Save the exercise data and return to previous screen
  void _saveExercise() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exerciseData = {
      'name': _exerciseNameController.text.trim(),
      'sets': int.parse(_setsController.text.trim()),
      'reps': int.parse(_repsController.text.trim()),
      'weight': double.parse(_weightController.text.trim()),
      'muscleGroup': _selectedMuscleGroup!,
    };

    Navigator.pop(context, exerciseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
        backgroundColor: Colors.deepOrange[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _exerciseNameController,
                keyboardType: TextInputType.text,
                decoration: _fieldDecoration(
                  labelText: 'Exercise Name',
                  hintText: 'e.g. Barbell Squat',
                  icon: Icons.fitness_center,
                ),
                validator: _validateExerciseName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _setsController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  labelText: 'Sets',
                  hintText: 'e.g. 3',
                  icon: Icons.repeat,
                ),
                validator: _validateSets,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                decoration: _fieldDecoration(
                  labelText: 'Reps',
                  hintText: 'e.g. 10',
                  icon: Icons.format_list_numbered,
                ),
                validator: _validateReps,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _fieldDecoration(
                  labelText: 'Weight',
                  hintText: 'e.g. 20',
                  icon: Icons.monitor_weight_outlined,
                  suffixText: 'kg',
                ),
                validator: _validateWeight,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMuscleGroup,
                decoration: _fieldDecoration(
                  labelText: 'Target Muscle Group',
                  icon: Icons.accessibility_new,
                ).copyWith(
                  hint: const Text('Select Muscle Group...'),
                ),
                items: _muscleGroups
                    .map(
                      (group) => DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMuscleGroup = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a muscle group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Text(
                  _volumePreview,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveExercise,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Exercise'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
