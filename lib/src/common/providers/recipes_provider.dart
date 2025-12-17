import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../recipes/data/recipe_repository.dart';
import '../models/recipe.dart';

final savedRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(recipeRepositoryProvider).watchSavedRecipes(user.uid);
});
