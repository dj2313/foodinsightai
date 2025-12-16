import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

import '../common/models/pantry_item.dart';
import '../common/models/recipe.dart';
import '../common/models/nutrition_info.dart';
import 'ai_constants.dart';

final chefServiceProvider = Provider((ref) => ChefService());

class ChefService {
  late final GenerativeModel _model;
  final Uuid _uuid = const Uuid();

  ChefService() {
    _model = GenerativeModel(
      model: AIConstants.geminiModel,
      apiKey: AIConstants.geminiApiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<Recipe> generateRecipe(List<PantryItem> pantryItems) async {
    final ingredientsList = pantryItems
        .map(
          (e) =>
              '${e.name} (${e.expiry != null ? "expiring soon" : "available"})',
        )
        .join(', ');

    final prompt = Content.text(
      'Create a detailed recipe using some of these ingredients: $ingredientsList. '
      'You can assume common staples like salt, pepper, oil, water are available. '
      'Return a SINGLE JSON object with this schema: \n'
      '{\n'
      '  "title": "Recipe Name",\n'
      '  "durationMinutes": 30,\n'
      '  "calories": 500,\n'
      '  "tags": ["Healthy", "Dinner"],\n'
      '  "ingredients": ["1 cup Rice", "2 Tomatoes", ...],\n'
      '  "instructions": ["Step 1...", "Step 2..."],\n'
      '  "nutrition": {"protein": 20, "carbs": 50, "fat": 15, "fiber": 5, "vitaminC": 10}\n'
      '}',
    );

    try {
      final response = await _model.generateContent([prompt]);
      final text = response.text;

      if (text == null) throw Exception('No response from Chef AI');

      // Clean up markdown
      String jsonString = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final startIndex = jsonString.indexOf('{');
      final endIndex = jsonString.lastIndexOf('}');
      if (startIndex != -1 && endIndex != -1) {
        jsonString = jsonString.substring(startIndex, endIndex + 1);
      }

      final Map<String, dynamic> json = jsonDecode(jsonString);

      return Recipe(
        id: _uuid.v4(),
        title: json['title'] ?? 'AI Surprise Meal',
        imageUrl: 'https://via.placeholder.com/600x400', // Placeholder for now
        durationMinutes: json['durationMinutes'] as int? ?? 30,
        calories: json['calories'] as int? ?? 400,
        tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
        ingredients:
            (json['ingredients'] as List?)?.map((e) => e.toString()).toList() ??
            [],
        instructions:
            (json['instructions'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        nutrition: json['nutrition'] != null
            ? NutritionInfo(
                calories: json['calories'] as int? ?? 0,
                protein:
                    (json['nutrition']['protein'] as num?)?.toDouble() ?? 0,
                carbs: (json['nutrition']['carbs'] as num?)?.toDouble() ?? 0,
                fat: (json['nutrition']['fat'] as num?)?.toDouble() ?? 0,
                fiber: (json['nutrition']['fiber'] as num?)?.toDouble() ?? 0,
                vitaminC:
                    (json['nutrition']['vitaminC'] as num?)?.toDouble() ?? 0,
              )
            : null,
      );
    } catch (e) {
      print('Chef AI Error: $e');
      throw Exception('Failed to generate recipe');
    }
  }
}
