import 'package:flutter/material.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  const DietaryPreferencesScreen({super.key});

  @override
  State<DietaryPreferencesScreen> createState() =>
      _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  final Map<String, bool> _preferences = {
    'Vegetarian': false,
    'Vegan': false,
    'Gluten-Free': false,
    'Dairy-Free': false,
    'Keto': false,
    'Paleo': false,
    'Low-Carb': false,
    'High-Protein': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dietary Preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Select your dietary preferences to get personalized recipe recommendations.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ..._preferences.keys.map(
            (key) => CheckboxListTile(
              title: Text(key),
              value: _preferences[key],
              onChanged: (value) {
                setState(() => _preferences[key] = value ?? false);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
