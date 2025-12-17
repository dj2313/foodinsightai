import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Test script to verify OpenRouter API is working
/// Run with: dart run test/test_openrouter_api.dart
void main() async {
  print('🔍 Testing OpenRouter API...\n');

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
    print('✅ .env file loaded');
  } catch (e) {
    print('❌ Error loading .env file: $e');
    print('Make sure .env exists in project root with OPENROUTER_API_KEY');
    exit(1);
  }

  // Check API key
  final apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    print('❌ OPENROUTER_API_KEY not found in .env file');
    exit(1);
  }

  print('✅ API Key found: ${apiKey.substring(0, 10)}...\n');

  // Test 1: Simple text completion
  print('📝 Test 1: Simple text completion...');
  await testTextCompletion(apiKey);

  print('\n');

  // Test 2: Vision (image analysis)
  print('🖼️  Test 2: Vision capability...');
  await testVisionCapability(apiKey);

  print('\n✅ All tests completed!');
}

Future<void> testTextCompletion(String apiKey) async {
  try {
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://mealplanner.app',
        'X-Title': 'FoodSight AI Test',
      },
      body: jsonEncode({
        'model': 'anthropic/claude-sonnet-4.5',
        'messages': [
          {
            'role': 'user',
            'content': 'Say "Hello from Claude!" and nothing else.',
          },
        ],
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      print('   ✅ Status: ${response.statusCode}');
      print('   ✅ Response: $content');
      print('   ✅ Model: anthropic/claude-sonnet-4.5 is working!');
    } else {
      print('   ❌ Status: ${response.statusCode}');
      print('   ❌ Error: ${response.body}');

      // Check for common errors
      if (response.statusCode == 401) {
        print(
          '   💡 Tip: Invalid API key. Check your OPENROUTER_API_KEY in .env',
        );
      } else if (response.statusCode == 404) {
        print('   💡 Tip: Model not found. Check model name spelling.');
      } else if (response.statusCode == 429) {
        print('   💡 Tip: Rate limit exceeded. Wait a moment and try again.');
      }
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }
}

Future<void> testVisionCapability(String apiKey) async {
  // Create a simple 1x1 red pixel image in base64
  // This is just to test if the model accepts image input
  const testImageBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg==';

  try {
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://mealplanner.app',
        'X-Title': 'FoodSight AI Test',
      },
      body: jsonEncode({
        'model': 'anthropic/claude-sonnet-4.5',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    'What color is this image? Reply with just the color name.',
              },
              {
                'type': 'image_url',
                'image_url': {'url': 'data:image/png;base64,$testImageBase64'},
              },
            ],
          },
        ],
        'max_tokens': 50,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      print('   ✅ Status: ${response.statusCode}');
      print('   ✅ Response: $content');
      print('   ✅ Vision support confirmed! Model can analyze images.');
    } else {
      print('   ❌ Status: ${response.statusCode}');
      print('   ❌ Error: ${response.body}');

      if (response.body.contains('vision') || response.body.contains('image')) {
        print(
          '   💡 Tip: This model may not support vision. Try a different model.',
        );
      }
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }
}
