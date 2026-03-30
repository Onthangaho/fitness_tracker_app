import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/exercise_search_provider.dart';

class ExerciseSearchScreen extends StatefulWidget {
  const ExerciseSearchScreen({super.key});

  @override
  State<ExerciseSearchScreen> createState() => _ExerciseSearchScreenState();
}

class _ExerciseSearchScreenState extends State<ExerciseSearchScreen> {
  final TextEditingController _nameController = TextEditingController();

  String? _selectedMuscle;
  String? _selectedDifficulty;
  String? _selectedType;

  static const List<String> _muscles = [
    'abdominals',
    'abductors',
    'adductors',
    'biceps',
    'calves',
    'chest',
    'forearms',
    'glutes',
    'hamstrings',
    'lats',
    'lower_back',
    'middle_back',
    'neck',
    'quadriceps',
    'traps',
    'triceps',
  ];

  static const List<String> _difficulties = [
    'beginner',
    'intermediate',
    'expert',
  ];

  static const List<String> _types = [
    'strength',
    'stretching',
    'cardio',
    'plyometrics',
    'powerlifting',
    'strongman',
    'olympic_weightlifting',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    context.read<ExerciseSearchProvider>().searchExercises(
      muscle: _selectedMuscle,
      type: _selectedType,
      difficulty: _selectedDifficulty,
      name: _nameController.text,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedMuscle = null;
      _selectedDifficulty = null;
      _selectedType = null;
      _nameController.clear();
    });
    context.read<ExerciseSearchProvider>().clearResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Exercise Search')
      ,
      backgroundColor: Colors.deepOrange[900],
      foregroundColor: Colors.white,),
      
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<ExerciseSearchProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      onSubmitted: (_) => _submitSearch(),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        labelText: 'Exercise name (optional)',
                        hintText: 'e.g., curl, squat, press',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: provider.isLoading ? null : _submitSearch,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedMuscle,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Muscle Group',
                        border: OutlineInputBorder(),
                      ),
                      items: _muscles
                          .map(
                            (muscle) => DropdownMenuItem(
                              value: muscle,
                              child: Text(muscle.replaceAll('_', ' ')),
                            ),
                          )
                          .toList(),
                      onChanged: provider.isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedMuscle = value;
                              });
                            },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedDifficulty,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Difficulty',
                              border: OutlineInputBorder(),
                            ),
                            items: _difficulties
                                .map(
                                  (difficulty) => DropdownMenuItem(
                                    value: difficulty,
                                    child: Text(difficulty),
                                  ),
                                )
                                .toList(),
                            onChanged: provider.isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedDifficulty = value;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedType,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                            ),
                            items: _types
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type.replaceAll('_', ' ')),
                                  ),
                                )
                                .toList(),
                            onChanged: provider.isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedType = value;
                                    });
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : _submitSearch,
                            icon: const Icon(Icons.search),
                            label: const Text('Search'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : _clearFilters,
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<ExerciseSearchProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_off,
                            size: 52,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.errorMessage ?? 'Something went wrong.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          FilledButton.tonal(
                            onPressed: provider.retry,
                            child: const Text('Tap to Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.hasResults) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${provider.searchResults.length} exercises found',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.searchResults.length,
                            itemBuilder: (context, index) {
                              final exercise = provider.searchResults[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    exercise.name.isNotEmpty
                                        ? exercise.name
                                        : 'Unnamed Exercise',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        Chip(
                                          label: Text(
                                            'Muscle: ${exercise.muscle.isNotEmpty ? exercise.muscle : 'Unknown'}',
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            'Type: ${exercise.type.isNotEmpty ? exercise.type : 'Unknown'}',
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            'Difficulty: ${exercise.difficulty.isNotEmpty ? exercise.difficulty : 'Unknown'}',
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            'Equipment: ${exercise.equipment.isNotEmpty ? exercise.equipment : 'None'}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  childrenPadding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  children: [
                                    //this 
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        exercise.instructions.isNotEmpty
                                            ? exercise.instructions
                                            : 'No instructions provided.',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  if (provider.lastQuery.isNotEmpty) {
                    return Center(
                      child: Text(
                        'No exercises found for "${provider.lastQuery}". Try different filters.',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 56,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Select filters and search for exercises',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
