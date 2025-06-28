// your_aiservice_file.dart (or wherever your AIService is located)
import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';

class AIService {
  Future<List<Map<String, dynamic>>> generateMCQs() async {
    final prompt = '''
Generate 10 multiple choice questions (MCQs) on the topic of climate change.
Each question should be in this format:
{
  "question": "What is the main cause of global warming?",
  "options": ["Deforestation", "Plastic usage", "Volcanic eruptions", "Solar flares"],
  "answer": "Deforestation"
}
Return ONLY a JSON list of 10 such objects, without any additional text, markdown formatting (like ```json), or explanations.
''';

    try {
      final response = await Gemini.instance.text(prompt);

      if (response == null ||
          response.content == null ||
          response.content!.parts == null ||
          response.content!.parts!.isEmpty) {
        throw Exception('Gemini API response did not contain valid content or was filtered.');
      }

      String? content;
      if (response.content!.parts![0] is TextPart) {
        content = (response.content!.parts![0] as TextPart).text;
      }

      if (content == null || content.isEmpty) {
        throw Exception('Gemini API response contained an empty or non-text content part.');
      }

      final startIndex = content.indexOf('[');
      final endIndex = content.lastIndexOf(']');

      if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
        final jsonString = content.substring(startIndex, endIndex + 1);

        try {
          return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
        } on FormatException catch (e) {
          throw Exception('Failed to parse JSON from model response. JSON might be malformed. Error: $e. Raw content: $jsonString');
        }
      } else {
        throw Exception('Failed to extract JSON array from model response. Check if brackets are present or properly formed. Raw content: $content');
      }
    } catch (e) {
      throw Exception('Error generating MCQs with Gemini: $e');
    }
  }
}