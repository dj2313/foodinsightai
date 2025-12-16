import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/recipe.dart';
import '../models/nutrition_info.dart';
import 'pantry_provider.dart';

final recipesProvider =
    Provider.autoDispose<List<Recipe>>((ref) => _seedRecipes);

final filteredRecipesProvider = Provider.autoDispose<List<Recipe>>((ref) {
  final pantry = ref.watch(pantryProvider);
  final recipes = ref.watch(recipesProvider);
  if (pantry.isEmpty) return recipes;
  // Simple heuristic: keep recipes that have any matched pantry items.
  return recipes
      .where(
        (r) => r.matchedPantryItems.any(
          (item) => pantry.any((p) => p.name.toLowerCase() == item.toLowerCase()),
        ),
      )
      .toList();
});

const _seedRecipes = <Recipe>[
  Recipe(
    id: 'r1',
    title: 'Avocado & Egg Power Bowl',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCMF87U2kj0Y4pBqOsIcDtnk_E4bkzYyXZcoOyI7RSJ8XUYHowTxMHMhF-fPtsNQmGrpn0W4ml28f4K8kEUO5smm___iB4UR5S0Zx3h9vx3V46oMJDWPtwyBonsU5lQw1nsX8cqMK-E8Q52LlgKTPVLhtpZ9e8tmexF6apVAjax6UfYpYtmLnPj73HqH4Efg3mspPOyof0XA-zPsi_CBD0zfVbmCIj8m7UfoTkDcJH6KwJZxWF4CA_PCLJ-vgfax8dtgcDe18iQu_mA',
    durationMinutes: 15,
    calories: 350,
    tags: ['Breakfast', 'AI Picks', 'Healthy'],
    matchedPantryItems: ['Avocado'],
    nutrition: NutritionInfo(
      calories: 350,
      protein: 18,
      carbs: 28,
      fat: 18,
      fiber: 6,
      vitaminC: 15,
    ),
  ),
  Recipe(
    id: 'r2',
    title: 'Artisan Basil Pizza',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBXZGk0_hC5nfw9QHe6HZKAGBebfMruAw67zp46iLCt7ja-Bemd33B3jjfgaKyMYSc7dH1tmS44isfc_K0E3N1dryt8qLH1BiNTJFcjBDpq_QMPXigyx3Q377OfNipPuHL0TjnHzGc4a9c8Lx70upUfcSHp_kRbgbOzwrY5muNHW6IN7xmvx2oGQZRMKBvSS8VmA14t7a9tPey6e45Lv7BaXkI6AJncTIdVfw65VRLNfqfciAbOuU1PyHV36hHAfNe-Ni1STDXcg8EW',
    durationMinutes: 45,
    calories: 620,
    tags: ['Dinner'],
    matchedPantryItems: ['Spinach'],
    nutrition: NutritionInfo(
      calories: 620,
      protein: 20,
      carbs: 70,
      fat: 28,
      fiber: 4,
      vitaminC: 12,
    ),
  ),
  Recipe(
    id: 'r3',
    title: 'Blueberry French Toast',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCr8AeuVCYJyW39YheOhtZSWilZ8c_2CPzbDMZpzEv-0L5xSBab2UD4UKZB61UL4DMgMdDoyf1Q2jsBS4GSKriYdLeogduWOvfQHHArqe6lB3Or3wWfbRa4YCZ4zHqykxYsHSkbu5Yl8x5F8440wKMOCnbV5OUaCYD7zRdRMFWBA13cjPlO4v4QufCI3mn_lzHUcbwZEBML7hSTsSwY5H5hikLJWdaSNMpYQEcnRoq_LAj07WENXYxScZrRD6mZGGvAWDqncdL_UeGo',
    durationMinutes: 20,
    calories: 480,
    tags: ['Sweet', 'Breakfast'],
    matchedPantryItems: ['Bread'],
    nutrition: NutritionInfo(
      calories: 480,
      protein: 12,
      carbs: 55,
      fat: 22,
      fiber: 3,
      vitaminC: 8,
    ),
  ),
];

