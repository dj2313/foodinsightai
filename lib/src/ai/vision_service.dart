import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/models/pantry_item.dart';
import 'ai_constants.dart';

final visionServiceProvider = Provider((ref) => VisionService());

class VisionService {
  final Uuid _uuid = const Uuid();
  static const int _maxDailyScans = 2; // Strict limit: 2 scans per day

  Future<void> _checkRateLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateFormat('yyyyMMdd').format(DateTime.now());
    final String key = 'vision_scans_$today';

    final int scansToday = prefs.getInt(key) ?? 0;
    print('Scans used today: $scansToday / $_maxDailyScans');

    if (scansToday >= _maxDailyScans) {
      throw Exception(
        'DAILY_LIMIT_REACHED: You have used your $_maxDailyScans free scans for today. Try manually adding items!',
      );
    }
  }

  Future<void> _incrementScanCount() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateFormat('yyyyMMdd').format(DateTime.now());
    final String key = 'vision_scans_$today';

    final int scansToday = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, scansToday + 1);
  }

  Future<List<PantryItem>> analyzeImage(XFile imageFile) async {
    // 1. Check Rate Limit
    await _checkRateLimit();

    try {
      print('Starting image analysis...');
      print('API Key present: ${AIConstants.openRouterApiKey.isNotEmpty}');
      print('Model: ${AIConstants.openRouterModel}');

      // Read image and convert to base64
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      print('Image size: ${imageBytes.length} bytes');

      // Prepare the request
      final response = await http.post(
        Uri.parse('${AIConstants.openRouterBaseUrl}/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${AIConstants.openRouterApiKey}',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://mealplanner.app',
          'X-Title': 'FoodInsight',
        },
        body: jsonEncode({
          'model': AIConstants.openRouterModel,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      'Analyze this image and identify all food items. '
                      'IMPORTANT: Use common Indian English names if applicable (e.g., use "Brinjal" instead of Eggplant, "Lady Finger" or "Bhindi" instead of Okra, "Curd" instead of Yogurt). '
                      'Return ONLY a valid JSON array with no additional text. '
                      'For each item, provide:\n'
                      '- item_name (string)\n'
                      '- category (one of: Vegetable, Fruit, Dairy, Meat, Pantry, Other)\n'
                      '- estimated_days_until_expiry (integer, sensible guess based on item type)\n\n'
                      'Example format: [{"item_name":"Tomato","category":"Vegetable","estimated_days_until_expiry":5}]',
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'},
                },
              ],
            },
          ],
          'temperature': 0.1, // Lower temperature for more consistent JSON
          'max_tokens': 1000,
        }),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('OpenRouter API error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('API request failed: ${response.statusCode}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String content = responseData['choices'][0]['message']['content'];

      print('OpenRouter response: $content'); // Debug log

      // Clean up the response
      String jsonString = content.trim();

      // Remove markdown code blocks if present
      jsonString = jsonString
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Extract JSON array
      final startIndex = jsonString.indexOf('[');
      final endIndex = jsonString.lastIndexOf(']');

      if (startIndex == -1 || endIndex == -1) {
        print('No JSON array found in response: $jsonString');
        throw Exception('AI response format error. Please try again.');
      }

      jsonString = jsonString.substring(startIndex, endIndex + 1);

      final List<dynamic> jsonList = jsonDecode(jsonString);

      if (jsonList.isEmpty) {
        print('No items identified in image');
        return [];
      }

      // 2. Increment usage only on success
      await _incrementScanCount();

      return jsonList.map((json) {
        final days = json['estimated_days_until_expiry'] as int? ?? 7;
        final expiryDate = DateTime.now().add(Duration(days: days));

        return PantryItem(
          id: _uuid.v4(),
          name: json['item_name'] ?? 'Unknown Item',
          quantityLabel: '1 unit',
          category: json['category'] ?? 'Other',
          imageUrl: '', // Will show fallback icon in UI
          expiry: expiryDate,
        );
      }).toList();
    } on FormatException catch (e) {
      print('JSON parsing error: $e');
      throw Exception('Failed to parse AI response. Please try again.');
    } catch (e) {
      print('Error analyzing image: $e');

      // Check for daily limit exception first
      if (e.toString().contains('DAILY_LIMIT_REACHED')) {
        rethrow;
      }

      // Check for common API errors
      if (e.toString().contains('API key') || e.toString().contains('401')) {
        throw Exception(
          'Invalid API key. Please check your OpenRouter API key.',
        );
      } else if (e.toString().contains('quota') ||
          e.toString().contains('429')) {
        throw Exception('API quota exceeded. Please try again later.');
      } else if (e.toString().contains('network') ||
          e.toString().contains('SocketException')) {
        throw Exception('Network error. Please check your connection.');
      }

      throw Exception('Failed to analyze image: ${e.toString()}');
    }
  }
}
