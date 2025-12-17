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
    required this.onScan,
  });

  final MainTab current;
  final void Function(MainTab) onSelect;
  final VoidCallback onScan;

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
        padding: const EdgeInsets.only(bottom: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.6)
                    : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    isActive: widget.current == MainTab.home,
                    isHovered: _hoveredIndex == 0,
                    onTap: () => widget.onSelect(MainTab.home),
                    onHover: (hovering) =>
                        setState(() => _hoveredIndex = hovering ? 0 : null),
                  ),
                  const SizedBox(width: 16),
                  _NavItem(
                    icon: Icons.restaurant_menu_rounded,
                    isActive: widget.current == MainTab.recipes,
                    isHovered: _hoveredIndex == 1,
                    onTap: () => widget.onSelect(MainTab.recipes),
                    onHover: (hovering) =>
                        setState(() => _hoveredIndex = hovering ? 1 : null),
                  ),
                  const SizedBox(width: 24),
                  // Center Scan Button
                  _ScanButton(onTap: widget.onScan),
                  const SizedBox(width: 24),
                  _NavItem(
                    icon: Icons.inventory_2_rounded,
                    isActive: widget.current == MainTab.pantry,
                    isHovered: _hoveredIndex == 2,
                    onTap: () => widget.onSelect(MainTab.pantry),
                    onHover: (hovering) =>
                        setState(() => _hoveredIndex = hovering ? 2 : null),
                  ),
                  const SizedBox(width: 16),
                  _NavItem(
                    icon: Icons.person_rounded,
                    isActive: widget.current == MainTab.profile,
                    isHovered: _hoveredIndex == 3,
                    onTap: () => widget.onSelect(MainTab.profile),
                    onHover: (hovering) =>
                        setState(() => _hoveredIndex = hovering ? 3 : null),
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
    required this.isActive,
    required this.isHovered,
    required this.onTap,
    required this.onHover,
  });

  final IconData icon;
  final bool isActive;
  final bool isHovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = const Color(0xFFFF7A00); // Brand Orange

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withOpacity(0.1)
                : (isHovered
                      ? (isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05))
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 24,
            color: isActive
                ? activeColor
                : (isDark ? Colors.white54 : Colors.black54),
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9100), Color(0xFFFF5E00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5E00).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.document_scanner_rounded, // or qr_code_scanner
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
