import 'package:fitness_tracker_app/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightGoalController;

  int? _restTimerDraft;
  bool _isEditingRestTimer = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) {
      return;
    }

    final profileProvider = context.read<ProfileProvider>();
    _nameController = TextEditingController(text: profileProvider.name);
    _ageController = TextEditingController(
      text: profileProvider.age == 0 ? '' : profileProvider.age.toString(),
    );
    _weightGoalController = TextEditingController(
      text: profileProvider.weightGoal == 0
          ? ''
          : profileProvider.weightGoal.toStringAsFixed(1),
    );
    _restTimerDraft = profileProvider.restTimerSeconds;
    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightGoalController.dispose();
    super.dispose();
  }

  Future<void> _saveName(ProfileProvider provider) async {
    await provider.saveName(_nameController.text);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Name saved')),
    );
  }

  Future<void> _saveAgeAndWeightGoal(ProfileProvider provider) async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final parsedAge = int.tryParse(_ageController.text.trim()) ?? 0;
    final parsedWeightGoal =
        double.tryParse(_weightGoalController.text.trim()) ?? 0.0;

    await provider.saveAge(parsedAge);
    await provider.saveWeightGoal(parsedWeightGoal);

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile values saved')),
    );
  }

  String _formatRestTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes == 0) {
      return '$seconds seconds';
    }
    if (remainingSeconds == 0) {
      return '$minutes min';
    }
    return '$minutes min $remainingSeconds sec';
  }

  Future<void> _confirmResetProfile(ProfileProvider provider) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Profile Data?'),
          content: const Text(
            'This will delete your personal profile data (name, age, and weight goal). Your preferences will stay as-is.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Reset Profile'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    await provider.resetProfile();
    _nameController.text = '';
    _ageController.text = '';
    _weightGoalController.text = '';

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile reset successfully')),
    );
  }

  Future<void> _confirmResetEverything(ProfileProvider provider) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset Everything?'),
          content: const Text(
            'This will delete all profile data and app preferences. Unit, rest timer, and notifications will be restored to defaults.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Reset Everything'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    await provider.resetEverything();
    _nameController.text = '';
    _ageController.text = '';
    _weightGoalController.text = '';
    setState(() {
      _restTimerDraft = provider.restTimerSeconds;
    });

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All data reset successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final restTimerValue = _isEditingRestTimer
        ? (_restTimerDraft ?? profileProvider.restTimerSeconds)
        : profileProvider.restTimerSeconds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () => _saveName(profileProvider),
                    icon: const Icon(Icons.save),
                    tooltip: 'Save name',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final raw = (value ?? '').trim();
                  if (raw.isEmpty) {
                    return 'Please enter your age';
                  }
                  final parsed = int.tryParse(raw);
                  if (parsed == null || parsed < 1 || parsed > 120) {
                    return 'Age must be a whole number between 1 and 120';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightGoalController,
                decoration: InputDecoration(
                  labelText: 'Weight goal',
                  border: const OutlineInputBorder(),
                  suffixText: profileProvider.weightUnit,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final raw = (value ?? '').trim();
                  if (raw.isEmpty) {
                    return 'Please enter your weight goal';
                  }
                  final parsed = double.tryParse(raw);
                  if (parsed == null || parsed <= 0) {
                    return 'Weight goal must be a positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: () => _saveAgeAndWeightGoal(profileProvider),
                  icon: const Icon(Icons.check),
                  label: const Text('Save Profile Values'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Preferences',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Weight unit',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'kg', label: Text('kg')),
                  ButtonSegment(value: 'lbs', label: Text('lbs')),
                ],
                selected: {profileProvider.weightUnit},
                onSelectionChanged: (selected) {
                  profileProvider.saveWeightUnit(selected.first);
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Rest timer: ${_formatRestTimer(restTimerValue)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                min: 15,
                max: 300,
                divisions: 19,
                label: _formatRestTimer(restTimerValue),
                value: restTimerValue.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _isEditingRestTimer = true;
                    _restTimerDraft = value.round();
                  });
                },
                onChangeEnd: (value) async {
                  final rounded = value.round();
                  await profileProvider.saveRestTimerSeconds(rounded);
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _isEditingRestTimer = false;
                    _restTimerDraft = rounded;
                  });
                },
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notifications enabled'),
                value: profileProvider.notificationsEnabled,
                onChanged: (value) {
                  profileProvider.saveNotificationsEnabled(value);
                },
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => _confirmResetProfile(profileProvider),
                child: const Text('Reset Profile'),
              ),
              const SizedBox(height: 10),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => _confirmResetEverything(profileProvider),
                child: const Text('Reset Everything'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}