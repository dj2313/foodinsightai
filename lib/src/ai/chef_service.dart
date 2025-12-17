import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../common/models/pantry_item.dart';
import '../common/models/recipe.dart';
import '../common/models/nutrition_info.dart';
import '../common/models/user_preferences.dart';
import 'ai_constants.dart';

final chefServiceProvider = Provider((ref) => ChefService());

class ChefService {
  final Uuid _uuid = const Uuid();

  Future<Recipe> generateRecipe(
    List<PantryItem> pantryItems,
    UserPreferences prefs,
  ) async {
    final ingredientsList = pantryItems
        .map(
          (e) =>
              '${e.name} (${e.expiry != null ? "expiring soon" : "available"})',
        )
        .join(', ');

    final String allergyContext = prefs.allergies.isNotEmpty
        ? "IMPORTANT: The user has these ALLERGIES: ${prefs.allergies.join(', ')}. ABSOLUTELY NO ingredients containing these. "
        : "";
    final String dietContext =
        "User follows a ${prefs.diet} diet. Goal: ${prefs.goals.join(', ')}.";

    try {
      final response = await http.post(
        Uri.parse('${AIConstants.openRouterBaseUrl}/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${AIConstants.openRouterApiKey}',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://mealplanner.app',
          'X-Title': 'FoodInsight',
        },
        body: jsonEncode({
          'model': AIConstants.openRouterModel,
          'messages': [
            {
              'role': 'user',
              'content':
                  'Create a detailed recipe using some of these ingredients: $ingredientsList. '
                  '$allergyContext'
                  '$dietContext'
                  'You can assume common staples like salt, pepper, oil, water are available. '
                  'Return ONLY a valid JSON object with no additional text. '
                  'Use this exact schema:\n'
                  '{\n'
                  '  "title": "Recipe Name",\n'
                  '  "durationMinutes": 30,\n'
                  '  "calories": 500,\n'
                  '  "tags": ["Healthy", "Dinner"],\n'
                  '  "ingredients": ["1 cup Rice", "2 Tomatoes"],\n'
                  '  "instructions": ["Step 1...", "Step 2..."],\n'
                  '  "nutrition": {"protein": 20, "carbs": 50, "fat": 15, "fiber": 5, "vitaminC": 10}\n'
                  '}',
            },
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode != 200) {
        print('OpenRouter API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('API request failed: ${response.statusCode}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String content = responseData['choices'][0]['message']['content'];

      print('Chef AI response: $content'); // Debug log

      // Clean up markdown
      String jsonString = content
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final startIndex = jsonString.indexOf('{');
      final endIndex = jsonString.lastIndexOf('}');

      if (startIndex == -1 || endIndex == -1) {
        throw Exception('Invalid response format');
      }

      jsonString = jsonString.substring(startIndex, endIndex + 1);

      final Map<String, dynamic> json = jsonDecode(jsonString);

      return Recipe(
        id: _uuid.v4(),
        title: json['title'] ?? 'AI Surprise Meal',
        imageUrl: '', // Will show fallback icon in UI
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
      throw Exception('Failed to generate recipe: ${e.toString()}');
    }
  }
}
