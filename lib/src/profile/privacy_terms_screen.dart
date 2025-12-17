import 'package:flutter/material.dart';

class PrivacyTermsScreen extends StatelessWidget {
  const PrivacyTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Terms')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Last updated: December 2024\n\n'
            'Your privacy is important to us. This app collects and stores:\n\n'
            '• Account information (email, name)\n'
            '• Pantry items you scan\n'
            '• Recipes you save\n'
            '• App preferences\n\n'
            'All data is stored securely in Firebase and is only accessible to you.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 32),
          const Text(
            'Terms of Service',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'By using this app, you agree to:\n\n'
            '• Use the app for personal, non-commercial purposes\n'
            '• Not abuse or misuse the AI features\n'
            '• Keep your account secure\n'
            '• Respect the intellectual property of recipes\n\n'
            'The app is provided "as is" without warranties.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
