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
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'durationMinutes': durationMinutes,
      'calories': calories,
      'tags': tags,
      'matchedPantryItems': matchedPantryItems,
      'ingredients': ingredients,
      'instructions': instructions,
      'nutrition': nutrition?.toMap(),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map, String id) {
    return Recipe(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      durationMinutes: map['durationMinutes'] ?? 0,
      calories: map['calories'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      matchedPantryItems: List<String>.from(map['matchedPantryItems'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      nutrition: map['nutrition'] != null
          ? NutritionInfo.fromMap(map['nutrition'])
          : null,
    );
  }
}
