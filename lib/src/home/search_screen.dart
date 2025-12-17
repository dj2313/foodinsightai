import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../common/providers/pantry_provider.dart';
import '../common/providers/recipes_provider.dart';
import '../common/models/pantry_item.dart';
import '../common/models/recipe.dart';
import '../recipes/recipe_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pantryAsync = ref.watch(pantryProvider);
    final recipesAsync = ref.watch(savedRecipesProvider);

    final pantryItems = pantryAsync.asData?.value ?? [];
    final recipes = recipesAsync.asData?.value ?? [];

    final filteredPantry = _query.isEmpty
        ? <PantryItem>[]
        : pantryItems
              .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    final filteredRecipes = _query.isEmpty
        ? <Recipe>[]
        : recipes
              .where(
                (e) => e.title.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search pantry & recipes...',
            border: InputBorder.none,
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search your kitchen',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (filteredPantry.isNotEmpty) ...[
                  Text(
                    'PANTRY ITEMS',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...filteredPantry.map(
                    (item) => _PantryResultTile(item: item),
                  ),
                  const SizedBox(height: 24),
                ],
                if (filteredRecipes.isNotEmpty) ...[
                  Text(
                    'SAVED RECIPES',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...filteredRecipes.map(
                    (recipe) => _RecipeResultTile(recipe: recipe),
                  ),
                ],
                if (filteredPantry.isEmpty && filteredRecipes.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        'No matches found for "$_query"',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PantryResultTile extends StatelessWidget {
  const _PantryResultTile({required this.item});
  final PantryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: item.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.fastfood, size: 20),
                ),
              )
            : const Icon(Icons.fastfood, size: 20),
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${item.quantityLabel} • ${item.statusLabel}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      onTap: () {
        // Navigate to pantry or show dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name} is in your pantry!')),
        );
      },
    );
  }
}

class _RecipeResultTile extends StatelessWidget {
  const _RecipeResultTile({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: recipe.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.restaurant, size: 20),
                ),
              )
            : const Icon(Icons.restaurant, size: 20),
      ),
      title: Text(
        recipe.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${recipe.durationMinutes} min • ${recipe.calories} kcal',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
        );
      },
    );
  }
}
