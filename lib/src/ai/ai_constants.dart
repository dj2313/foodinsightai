import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIConstants {
  // OpenRouter API Configuration
  static String get openRouterApiKey => dotenv.env['OPENROUTER_API_KEY'] ?? '';

  // Current: Gemini Flash 1.5 (Known strong vision support)
  // ⚠️ DeepSeek V3.2 does not support image input on this endpoint
  static const String openRouterModel = 'google/gemini-flash-1.5';

  // Alternative:
  // static const String openRouterModel = 'openai/gpt-4o-mini';

  // OpenRouter API endpoint
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
}
