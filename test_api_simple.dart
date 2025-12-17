import 'dart:convert';
import 'dart:io';

/// Simple test script to verify OpenRouter API
/// Run with: dart test_api_simple.dart
void main() async {
  print('🔍 Testing OpenRouter API...\n');

  // Read .env file manually
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ .env file not found in project root');
    print('Create .env file with: OPENROUTER_API_KEY=your_key_here');
    exit(1);
  }

  final envContent = await envFile.readAsString();
  final apiKeyLine = envContent
      .split('\n')
      .firstWhere(
        (line) => line.startsWith('OPENROUTER_API_KEY='),
        orElse: () => '',
      );

  if (apiKeyLine.isEmpty) {
    print('❌ OPENROUTER_API_KEY not found in .env file');
    exit(1);
  }

  final apiKey = apiKeyLine.split('=')[1].trim();
  print('✅ API Key found: ${apiKey.substring(0, 10)}...\n');

  // Test the API
  print('📝 Testing Claude Sonnet 4.5...');

  final client = HttpClient();
  try {
    final request = await client.postUrl(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
    );

    request.headers.set('Authorization', 'Bearer $apiKey');
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('HTTP-Referer', 'https://mealplanner.app');
    request.headers.set('X-Title', 'FoodSight AI Test');

    final body = jsonEncode({
      'model': 'anthropic/claude-sonnet-4.5',
      'messages': [
        {'role': 'user', 'content': 'Say "API is working!" and nothing else.'},
      ],
      'max_tokens': 50,
    });

    request.write(body);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final content = data['choices'][0]['message']['content'];
      print('✅ Response: $content');
      print('✅ Model: anthropic/claude-sonnet-4.5 is working!');
      print('\n🎉 API test successful! You can now run your app.');
    } else {
      print('❌ Error Response:');
      print(responseBody);

      if (response.statusCode == 401) {
        print('\n💡 Invalid API key. Check OPENROUTER_API_KEY in .env');
      } else if (response.statusCode == 404) {
        print('\n💡 Model not found. The model name might be incorrect.');
        print('Try: anthropic/claude-3.5-sonnet instead');
      } else if (response.statusCode == 429) {
        print('\n💡 Rate limit exceeded. Wait a moment and try again.');
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    client.close();
  }
}
