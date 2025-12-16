import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIConstants {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String geminiModel = 'gemini-1.5-flash';
}
