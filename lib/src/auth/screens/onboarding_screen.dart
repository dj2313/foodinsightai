import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../auth_providers.dart';
import '../providers/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    ref.read(hasSeenOnboardingProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final pages = ref.watch(onboardingPagesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final data = pages[index];
                return _OnboardingPage(
                  data: data,
                  onPrimary: () {
                    if (index < pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                );
              },
            ),
            // Page Indicator
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 100,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white38,
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 4,
                    spacing: 8,
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

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data, required this.onPrimary});

  final OnboardingPageData data;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl: data.bgUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.black12),
          errorWidget: (context, url, error) =>
              Container(color: Colors.grey.shade900),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.95),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Content: Header
                const Spacer(flex: 2),
                Text(
                      'Welcome to FoodSight AI'.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 16),

                Text(
                      data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideX(begin: -0.1, end: 0),

                const SizedBox(height: 16),

                Text(
                  data.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.5,
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms),

                const Spacer(flex: 3),

                // Bottom Content: Card & Button
                if (data.badgeTitle.isNotEmpty)
                  _GlassCard(
                        accent: data.accent,
                        title: data.badgeTitle,
                        subtitle: data.badgeSubtitle,
                      )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 48), // Space for indicator

                _ActionBtn(
                  text: data.ctaText,
                  onPressed: onPrimary,
                  accent: data.accent,
                ).animate().scale(
                  delay: 700.ms,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.accent,
    required this.title,
    required this.subtitle,
  });

  final Color accent;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_awesome, color: accent, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.text,
    required this.onPressed,
    required this.accent,
  });

  final String text;
  final VoidCallback onPressed;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: accent.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }
}
