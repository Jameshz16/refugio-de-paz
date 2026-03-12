import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse.dart';
import '../core/config.dart';
import '../core/logger.dart';

class AIService {
  final http.Client _client;

  AIService({http.Client? client}) : _client = client ?? http.Client();

  Future<Verse?> getComfortingVerse(String feeling, String emotion) async {
    try {
      final response = await _client.post(
        Uri.parse(AppConfig.deepseekApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.deepseekApiKey}',
        },
        body: jsonEncode({
          "model": "deepseek-chat",
          "messages": [
            {
              "role": "system",
              "content": "Eres un amable asistente cristiano espiritual enfocado en consolar. Cuando el usuario exprese cómo se siente y su emoción asóciala a sabiduría bíblica. Devuelve SOLAMENTE un objeto JSON con 4 claves: 'verse_text' (el verso bíblico), 'verse_reference' (la cita), 'prayer' (una pequeña oración de aliento) y 'explanation' (una breve frase de aliento o explicación de por qué este versículo acompaña su emoción)."
            },
            {
              "role": "user",
              "content": "Emoción: $emotion. Me siento: $feeling"
            }
          ],
          "response_format": {
            "type": "json_object"
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final contentStr = data['choices'][0]['message']['content'];
        final jsonData = jsonDecode(contentStr);

        final prayerBase = jsonData['prayer'] ?? 'Señor, dale paz a mi corazón en medio de todo.';
        final explanation = jsonData['explanation'] ?? '';
        final finalPrayer = explanation.isNotEmpty ? "$explanation\n\nOración:\n$prayerBase" : prayerBase;

        LoggerService.info('Verso generado exitosamente', data: {'emotion': emotion});

        return Verse(
          text: jsonData['verse_text'] ?? 'Confía en el Señor con todo tu corazón.',
          reference: jsonData['verse_reference'] ?? 'Proverbios 3:5',
          prayer: finalPrayer,
          date: DateTime.now(),
        );
      } else {
        LoggerService.error(
          'Error desde la API de DeepSeek',
          data: {'statusCode': response.statusCode},
        );
        return null;
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Excepción en AIService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
