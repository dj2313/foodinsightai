import 'nutrition_info.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final int durationMinutes;
  final int calories;
  final List<String> tags;
  final List<String> matchedPantryItems;
  final NutritionInfo? nutrition;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.durationMinutes,
    required this.calories,
    required this.tags,
    this.matchedPantryItems = const [],
    this.nutrition,
    this.ingredients = const [],
    this.instructions = const [],
  });

  final List<String> ingredients;
  final List<String> instructions;
}
