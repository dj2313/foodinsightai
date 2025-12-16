import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../common/models/pantry_item.dart';
import 'ai_constants.dart';

final visionServiceProvider = Provider((ref) => VisionService());

class VisionService {
  late final GenerativeModel _model;
  final Uuid _uuid = const Uuid();

  VisionService() {
    _model = GenerativeModel(
      model: AIConstants.geminiModel,
      apiKey: AIConstants.geminiApiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );
  }

  Future<List<PantryItem>> analyzeImage(XFile imageFile) async {
    final Uint8List imageBytes = await imageFile.readAsBytes();

    final prompt = Content.multi([
      TextPart(
        'Analyze this image and identify all food items. Return a JSON list of items. '
        'For each item, provide:\n'
        '- item_name (string)\n'
        '- category (Vegetable, Fruit, Dairy, Meat, Pantry, Other)\n'
        '- estimated_days_until_expiry (int, sensible guess based on item type)\n',
      ),
      DataPart('image/jpeg', imageBytes),
    ]);

    try {
      final response = await _model.generateContent([prompt]);
      final text = response.text;

      if (text == null) return [];

      // Clean up markdown code blocks if present (Gemini might return ```json ... ```)
      String jsonString = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Some simple cleanup if the model adds extra text
      final startIndex = jsonString.indexOf('[');
      final endIndex = jsonString.lastIndexOf(']');
      if (startIndex != -1 && endIndex != -1) {
        jsonString = jsonString.substring(startIndex, endIndex + 1);
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((json) {
        final days = json['estimated_days_until_expiry'] as int? ?? 7;
        final expiryDate = DateTime.now().add(Duration(days: days));

        return PantryItem(
          id: _uuid.v4(),
          name: json['item_name'] ?? 'Unknown Item',
          quantityLabel: '1 unit', // Default quantity
          category: json['category'] ?? 'Other',
          imageUrl:
              'https://via.placeholder.com/150', // We don't have item-specific URLs yet
          expiry: expiryDate,
        );
      }).toList();
    } catch (e) {
      print('Error analyzing image: $e');
      throw Exception('Failed to analyze image with AI');
    }
  }
}
