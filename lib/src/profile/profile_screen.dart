import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_controller.dart';
import '../auth/auth_providers.dart';
import '../common/providers/theme_provider.dart';
import '../common/widgets/mobile_navbar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
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
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      children: [
                        _ProfileHeader(),
                        const SizedBox(height: 16),
                        _Section(
                          title: 'Preferences',
                          children: [
                            _RowTile(
                              icon: Icons.restaurant_menu,
                              label: 'Dietary Preferences',
                            ),
                            _RowTile(icon: Icons.flag, label: 'Health Goals'),
                            _RowTile(
                              icon: Icons.coronavirus,
                              label: 'Allergies',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'Appearance',
                          children: [
                            _SwitchTile(
                              icon: Icons.dark_mode,
                              label: 'Dark Mode',
                              value: themeMode == ThemeMode.dark,
                              onChanged: (_) =>
                                  ref.read(themeModeProvider.notifier).toggle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'Notifications',
                          children: [
                            _RowTile(icon: Icons.alarm, label: 'Expiry Alerts'),
                            _RowTile(
                              icon: Icons.notifications_active,
                              label: 'Meal Reminders',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'Insights & Data',
                          children: [
                            _RowTile(
                              icon: Icons.analytics,
                              label: 'Nutrition Analytics',
                            ),
                            _RowTile(
                              icon: Icons.history,
                              label: 'Scan History',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Section(
                          title: 'Account',
                          children: [
                            _RowTile(
                              icon: Icons.lock,
                              label: 'Change Password',
                            ),
                            _RowTile(
                              icon: Icons.description,
                              label: 'Privacy & Terms',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            foregroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signOut();
                            if (context.mounted) {
                              Navigator.of(
                                context,
                              ).pushNamedAndRemoveUntil('/', (route) => false);
                            }
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MobileNavbar(
                current: MainTab.profile,
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
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/pantry', (route) => false);
        break;
      case MainTab.profile:
        break;
    }
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateChangesProvider);
    final user = userAsync.value;

    final displayName = user?.displayName?.isNotEmpty ?? false
        ? user!.displayName!
        : (user?.email != null ? user!.email!.split('@').first : 'User');

    final email = user?.email ?? 'No email';
    final photoUrl = user?.photoURL;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Text(
                    displayName.isNotEmpty
                        ? displayName[0].toUpperCase()
                        : '👤',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(onPressed: () {}, child: const Text('Edit')),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    height: 1,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.05),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.12),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      secondary: CircleAvatar(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.12),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
