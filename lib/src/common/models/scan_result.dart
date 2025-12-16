import 'nutrition_info.dart';

class ScanResult {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double freshnessScore; // 0-1
  final String estimatedWeight;
  final String shelfLifeLabel;
  final String freshnessTip;
  final NutritionInfo nutrition;
  final List<String> suggestedRecipeIds;

  const ScanResult({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.freshnessScore,
    required this.estimatedWeight,
    required this.shelfLifeLabel,
    required this.freshnessTip,
    required this.nutrition,
    this.suggestedRecipeIds = const [],
  });
}

