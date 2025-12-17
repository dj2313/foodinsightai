import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/auth_gate.dart';
import 'common/providers/theme_provider.dart';
import 'pantry/pantry_screen.dart';
import 'profile/profile_screen.dart';
import 'recipes/recipes_screen.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodInsight',
      themeMode: themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: const AuthGate(),
      routes: {
        '/home': (_) => const AuthGate(), // AuthGate will route to HomeScreen
        '/pantry': (_) => const PantryScreen(),
        '/recipes': (_) => const RecipesScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

final _lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFEA2831),
    brightness: Brightness.light,
    background: const Color(0xFFF8F6F6),
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFFF8F6F6),
  fontFamily: 'Be Vietnam Pro',
);

final _darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFF7B00),
    brightness: Brightness.dark,
    background: const Color(0xFF211111),
    surface: const Color(0xFF111111),
  ),
  scaffoldBackgroundColor: const Color(0xFF211111),
  fontFamily: 'Be Vietnam Pro',
);
