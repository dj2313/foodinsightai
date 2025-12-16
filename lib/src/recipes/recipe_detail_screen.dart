import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../common/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: recipe.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _IconText(Icons.timer, '${recipe.durationMinutes} min'),
                      const SizedBox(width: 20),
                      _IconText(
                        Icons.local_fire_department,
                        '${recipe.calories} kcal',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (recipe.instructions.isNotEmpty) ...[
                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...recipe.instructions.map(
                      (step) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(step)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (recipe.ingredients.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...recipe.ingredients.map(
                      (ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '• $ing',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
