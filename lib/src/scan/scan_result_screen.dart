import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/models/scan_result.dart';
import '../common/providers/pantry_provider.dart';
import '../common/providers/recipes_provider.dart';

class ScanResultScreen extends ConsumerWidget {
  const ScanResultScreen({super.key, required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(recipesProvider);
    final suggestions =
        recipes.where((r) => result.suggestedRecipeIds.contains(r.id)).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'Scan Result',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(result.imageUrl, fit: BoxFit.cover),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco, color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                '${result.name} • Fresh',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${result.category} • ${result.estimatedWeight}',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      result.shelfLifeLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Freshness', value: '${(result.freshnessScore * 100).round()}%')),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Est. Weight', value: result.estimatedWeight)),
                ],
              ),
              const SizedBox(height: 18),
              _NutritionGrid(result: result),
              const SizedBox(height: 18),
              _ExpiryCard(result: result),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('More Details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(pantryProvider.notifier).addFromScan(result);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to pantry')),
                        );
                      },
                      icon: const Icon(Icons.kitchen),
                      label: const Text('Add to Pantry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Suggestions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final r = suggestions[index];
                    return _SuggestionCard(recipeTitle: r.title, imageUrl: r.imageUrl, time: r.durationMinutes, calories: r.calories);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _NutritionGrid extends StatelessWidget {
  const _NutritionGrid({required this.result});
  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final n = result.nutrition;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Breakdown (per 100g)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _pill('Calories', '${n.calories}'),
              _pill('Protein', '${n.protein} g'),
              _pill('Carbs', '${n.carbs} g'),
              _pill('Fat', '${n.fat} g'),
              _pill('Fiber', '${n.fiber} g'),
              _pill('Vit C', '${n.vitaminC} mg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ExpiryCard extends StatelessWidget {
  const _ExpiryCard({required this.result});
  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.12),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.hourglass_top, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shelf-life: ${result.shelfLifeLabel}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  result.freshnessTip,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.recipeTitle,
    required this.imageUrl,
    required this.time,
    required this.calories,
  });
  final String recipeTitle;
  final String imageUrl;
  final int time;
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl, height: 110, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipeTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 14),
                    const SizedBox(width: 4),
                    Text('$time min'),
                    const SizedBox(width: 10),
                    const Icon(Icons.local_fire_department, size: 14),
                    const SizedBox(width: 4),
                    Text('$calories kcal'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

