import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/models/pantry_item.dart';
import '../common/providers/pantry_provider.dart';
import '../common/widgets/mobile_navbar.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  String _search = '';
  String _category = 'All';
  final _categories = const [
    'All',
    'Vegetables',
    'Fruits',
    'Dairy',
    'Bakery',
    'Snacks',
  ];

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(pantryProvider);
    final filtered = items.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(
        _search.toLowerCase(),
      );
      final matchesCategory = _category == 'All' || item.category == _category;
      return matchesSearch && matchesCategory;
    }).toList();

    final expiringSoon = items
        .where(
          (e) =>
              e.status == PantryStatus.warning ||
              e.status == PantryStatus.urgent,
        )
        .length;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
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
                              'My Pantry',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${items.length} items • $expiringSoon expiring soon',
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
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search pantry items…',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setState(() => _search = v),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final selected = cat == _category;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) => setState(() => _category = cat),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: _categories.length,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return _PantryTile(item: item);
                      },
                    ),
                  ),
                ],
              ),
              MobileNavbar(
                current: MainTab.pantry,
                onSelect: (tab) => _handleNav(context, tab),
              ),
            ],
          ),
        ),
      ),
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
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/recipes', (route) => false);
        break;
      case MainTab.pantry:
        break;
      case MainTab.profile:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/profile', (route) => false);
        break;
    }
  }
}

class _PantryTile extends StatelessWidget {
  const _PantryTile({required this.item});
  final PantryItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.statusColor(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.quantityLabel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: color),
                    const SizedBox(width: 6),
                    Text(
                      _statusLabel(item),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  String _statusLabel(PantryItem item) {
    switch (item.status) {
      case PantryStatus.fresh:
        return 'Fresh';
      case PantryStatus.warning:
        return '3 days left';
      case PantryStatus.urgent:
        return 'Expires soon';
      case PantryStatus.expired:
        return 'Expired';
    }
  }
}
