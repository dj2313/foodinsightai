import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart';

import '../common/models/recipe.dart';
import '../common/providers/recipes_provider.dart';
import '../common/widgets/mobile_navbar.dart';
import '../common/utils/scan_helper.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  final _filters = const [
    'All',
    'AI Picks',
    'Healthy',
    'Vegan',
    'Under 30 min',
  ];
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(savedRecipesProvider);

    return recipesAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (recipes) {
        final list = _selected == 'All'
            ? recipes
            : recipes.where((r) => r.tags.contains(_selected)).toList();

        // Placeholder for future logic
        // final basedOnPantry = list;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recipes',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your cookbook',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.tune),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search saved recipes…',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 44,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final f = _filters[index];
                            final selected = f == _selected;
                            return ChoiceChip(
                              label: Text(f),
                              selected: selected,
                              onSelected: (_) => setState(() => _selected = f),
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              labelStyle: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemCount: _filters.length,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                          children: [
                            if (list.isNotEmpty) ...[
                              _SectionHeader(title: 'Saved Recipes'),
                              const SizedBox(height: 12),
                              ...list.map((r) => _RecipeTile(recipe: r)),
                            ] else
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text("No saved recipes yet."),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  MobileNavbar(
                    current: MainTab.recipes,
                    onSelect: (tab) => _handleNav(context, tab),
                    onScan: () => ScanHelper.handleScan(context, ref),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNav(BuildContext context, MainTab tab) {
    switch (tab) {
      case MainTab.home:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
        break;
      case MainTab.recipes:
        break;
      case MainTab.pantry:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/pantry', (route) => false);
        break;
      case MainTab.profile:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        // TextButton(onPressed: () {}, child: const Text('See all')),
      ],
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            recipe.imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 72,
              height: 72,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          recipe.title,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${recipe.durationMinutes} min • ${recipe.calories} kcal',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }
}
