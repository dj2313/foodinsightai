import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home/home_screen.dart';
import 'auth_providers.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // TODO: decide when to show onboarding vs login based on local flag.
          return const OnboardingScreen();
        }
        return const HomeScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Auth error: $e'))),
    );
  }
}
