import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.badgeTitle,
    required this.badgeSubtitle,
    required this.ctaText,
    required this.bgUrl,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String badgeTitle;
  final String badgeSubtitle;
  final String ctaText;
  final String bgUrl;
  final Color accent;
}

final onboardingPagesProvider = Provider<List<OnboardingPageData>>((ref) {
  return [
    const OnboardingPageData(
      title: 'See Your Food Like Never Before.',
      subtitle: 'Scan. Analyze. Transform your food experience.',
      badgeTitle: 'AI-Powered Food Detection',
      badgeSubtitle: 'Identify ingredients instantly.',
      ctaText: 'Slide to Begin',
      bgUrl:
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=900&q=80',
      accent: Colors.deepOrange,
    ),
    const OnboardingPageData(
      title: 'Your Personal Meal Plan.',
      subtitle:
          'We’ll personalize recipes and schedules to match your lifestyle.',
      badgeTitle: 'Tell us your preferences',
      badgeSubtitle:
          'Share what you love, avoid, and your dietary goals.\nGet a weekly plan. Adjust as you go.',
      ctaText: 'Get Started',
      bgUrl:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?auto=format&fit=crop&w=900&q=80',
      accent: Colors.orange,
    ),
    const OnboardingPageData(
      title: 'Instant Food Recognition.',
      subtitle: 'Identify ingredients in seconds using advanced AI vision.',
      badgeTitle: 'AI that understands every ingredient in your plate.',
      badgeSubtitle: '',
      ctaText: 'Next',
      bgUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=80',
      accent: Colors.deepOrangeAccent,
    ),
  ];
});
