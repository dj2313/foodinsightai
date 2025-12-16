import 'dart:ui';
import 'package:flutter/material.dart';

/// Tabs used across the app.
enum MainTab { home, recipes, pantry, profile }

/// Glassmorphic mobile navbar with hover effects
class MobileNavbar extends StatefulWidget {
  const MobileNavbar({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final MainTab current;
  final void Function(MainTab) onSelect;

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.1)
                    : Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isActive: widget.current == MainTab.home,
                    isHovered: _hoveredIndex == 0,
                    onTap: () => widget.onSelect(MainTab.home),
                    onHover: (hovering) {
                      setState(() {
                        _hoveredIndex = hovering ? 0 : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _NavItem(
                    icon: Icons.restaurant_menu_rounded,
                    label: 'Recipes',
                    isActive: widget.current == MainTab.recipes,
                    isHovered: _hoveredIndex == 1,
                    onTap: () => widget.onSelect(MainTab.recipes),
                    onHover: (hovering) {
                      setState(() {
                        _hoveredIndex = hovering ? 1 : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _NavItem(
                    icon: Icons.inventory_2_rounded,
                    label: 'Pantry',
                    isActive: widget.current == MainTab.pantry,
                    isHovered: _hoveredIndex == 2,
                    onTap: () => widget.onSelect(MainTab.pantry),
                    onHover: (hovering) {
                      setState(() {
                        _hoveredIndex = hovering ? 2 : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isActive: widget.current == MainTab.profile,
                    isHovered: _hoveredIndex == 3,
                    onTap: () => widget.onSelect(MainTab.profile),
                    onHover: (hovering) {
                      setState(() {
                        _hoveredIndex = hovering ? 3 : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isHovered,
    required this.onTap,
    required this.onHover,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isHovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: 56,
              height: 56,
              transform: Matrix4.identity()
                ..translate(0.0, isHovered ? -8.0 : 0.0)
                ..scale(isHovered ? 1.1 : 1.0),
              decoration: BoxDecoration(
                color: isHovered ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isHovered
                        ? Colors.black
                        : (isDark
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.8)),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isHovered
                        ? Colors.black
                        : (isDark
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.8)),
                  ),
                ),
              ),
            ),
            // Label that appears below on hover or when active
            Positioned(
              top: 52,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: (isHovered || isActive) ? 1.0 : 0.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  transform: Matrix4.identity()
                    ..translate(0.0, (isHovered || isActive) ? 0.0 : 4.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
