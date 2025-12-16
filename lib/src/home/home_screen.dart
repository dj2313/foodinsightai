import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../common/toast.dart';
import '../common/widgets/scan_fab.dart';
import '../common/widgets/mobile_navbar.dart';
import '../ai/chef_service.dart';
import '../common/providers/pantry_provider.dart';
import '../recipes/recipe_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _generateMeal() async {
      AppToast.show('Chef AI is thinking...');
      try {
        final pantryItems = ref.read(pantryProvider);
        if (pantryItems.isEmpty) {
          AppToast.show('Pantry is empty! Scan some items first.');
          return;
        }

        final recipe = await ref
            .read(chefServiceProvider)
            .generateRecipe(pantryItems);

        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        }
      } catch (e) {
        AppToast.show('Error: $e');
      }
    }

    final userAsync = ref.watch(authStateChangesProvider);
    final user = userAsync.value;
    final name = (user?.displayName?.isNotEmpty ?? false)
        ? user!.displayName!
        : (user?.email != null ? user!.email!.split('@').first : 'Foodie');

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
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Header(
                                  name: name,
                                  onAvatarTap: () =>
                                      AppToast.show('Profile coming soon...'),
                                ),
                                const SizedBox(height: 16),
                                _SearchBar(),
                                const SizedBox(height: 20),
                                _SectionHeader(
                                  title: 'Featured',
                                  actionText: 'See all',
                                  onAction: () => AppToast.show(
                                    'See all featured coming soon',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _FeaturedRow(),
                                const SizedBox(height: 20),
                                _QuickActions(onMagicMeal: _generateMeal),
                                const SizedBox(height: 20),
                                Text(
                                  'Suggested For You',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onBackground,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const _SuggestedList(),
                                const SizedBox(height: 18),
                                const _DailySummaryCard(),
                                const SizedBox(height: 120),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(child: ScanFab()),
              ),
              MobileNavbar(
                current: MainTab.home,
                onSelect: (tab) => _handleNav(context, ref, tab),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNav(BuildContext context, WidgetRef ref, MainTab tab) {
    switch (tab) {
      case MainTab.home:
        break;
      case MainTab.recipes:
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/recipes', (route) => false);
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

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.onAvatarTap});
  final String name;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onBackground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                'Lets make something delicious.',
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _LiveAvatar(onTap: onAvatarTap),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppToast.show('Search coming soon...'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFFFD5530)),
            const SizedBox(width: 12),
            Text(
              'Search recipes, foods, cuisines...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionText, this.onAction});
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText!,
              style: const TextStyle(
                color: Color(0xFFE11D48),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _FeaturedRow extends StatelessWidget {
  final List<_FeaturedCardData> items = const [
    _FeaturedCardData(
      label: 'TRENDING',
      title: 'Quick Meals',
      tagColor: Color(0xFFE11D48),
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
    ),
    _FeaturedCardData(
      label: 'NEW',
      title: 'Fresh Finds',
      tagColor: Color(0xFF22C55E),
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80&sat=-20',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return _FeaturedCard(item: item);
        },
      ),
    );
  }
}

class _FeaturedCardData {
  const _FeaturedCardData({
    required this.label,
    required this.title,
    required this.tagColor,
    required this.image,
  });
  final String label;
  final String title;
  final Color tagColor;
  final String image;
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.item});
  final _FeaturedCardData item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppToast.show('${item.title} tapped'),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: CachedNetworkImageProvider(item.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.05),
                Colors.black.withOpacity(0.45),
              ],
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.tagColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onMagicMeal});
  final VoidCallback onMagicMeal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickAction(
          data: const _QuickActionData(
            icon: Icons.inventory_2_rounded,
            label: 'My Pantry',
          ),
          onTap: () => AppToast.show('Pantry coming soon...'),
        ),
        _QuickAction(
          data: const _QuickActionData(
            icon: Icons.auto_awesome,
            label: 'Magic Meal',
          ),
          onTap: onMagicMeal,
        ),
        _QuickAction(
          data: const _QuickActionData(
            icon: Icons.analytics_rounded,
            label: 'Nutrition\nBreakdown',
          ),
          onTap: () => AppToast.show('Analytics coming soon...'),
        ),
      ],
    );
  }
}

class _QuickActionData {
  const _QuickActionData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.data, required this.onTap});
  final _QuickActionData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(data.icon, color: const Color(0xFFE11D48), size: 28),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 90,
            child: Text(
              data.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestedList extends StatelessWidget {
  const _SuggestedList();

  final List<_SuggestedItem> items = const [
    _SuggestedItem(
      title: 'Avocado Toast',
      desc: 'Perfectly ripe avocado on sourdough with a poached...',
      calories: 350,
      tag: 'Breakfast',
      image:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=800&q=80',
      liked: true,
    ),
    _SuggestedItem(
      title: 'Grilled Salmon',
      desc: 'Rich in Omega-3, served with fresh asparagus.',
      calories: 450,
      tag: 'High Protein',
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80&sat=-30',
      liked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SuggestedCard(item: item),
            ),
          )
          .toList(),
    );
  }
}

class _SuggestedItem {
  const _SuggestedItem({
    required this.title,
    required this.desc,
    required this.calories,
    required this.tag,
    required this.image,
    required this.liked,
  });
  final String title;
  final String desc;
  final int calories;
  final String tag;
  final String image;
  final bool liked;
}

class _SuggestedCard extends StatelessWidget {
  const _SuggestedCard({required this.item});
  final _SuggestedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
            child: CachedNetworkImage(
              imageUrl: item.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        item.liked ? Icons.favorite : Icons.favorite_border,
                        color: item.liked
                            ? const Color(0xFFE11D48)
                            : const Color(0xFFC4C4C4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Chip(
                        label: '${item.calories} kcal',
                        bg: const Color(0xFFFFF4EC),
                        fg: const Color(0xFFE86B1D),
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: item.tag,
                        bg: const Color(0xFFEFF2F7),
                        fg: const Color(0xFF5B6472),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B0E17), Color(0xFF1B0E17), Color(0xFF301018)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'DAILY SUMMARY',
                  style: TextStyle(
                    color: Color(0xFF9AA0A6),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'You consumed 1200 kcal today.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 62,
                    height: 62,
                    child: CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 6,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE11D48),
                      ),
                    ),
                  ),
                  const Text(
                    '65%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveAvatar extends StatefulWidget {
  const _LiveAvatar({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_LiveAvatar> createState() => _LiveAvatarState();
}

class _LiveAvatarState extends State<_LiveAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 58,
        height: 58,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Pulsing Ring
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(
                          0xFFE11D48,
                        ).withOpacity(_opacityAnimation.value),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Avatar Image
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.background,
                  width: 3,
                ),
                image: const DecorationImage(
                  image: CachedNetworkImageProvider(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Live Status Badge
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
