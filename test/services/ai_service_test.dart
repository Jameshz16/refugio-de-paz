import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:refugio_de_paz/services/ai_service.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late AIService aiService;
  late MockClient mockClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    aiService = AIService(client: mockClient);
  });

  group('AIService', () {
    test('returns Verse on successful API response', () async {
      final responseJson = jsonEncode({
        'choices': [
          {
            'message': {
              'content': jsonEncode({
                'verse_text': 'El Señor es mi pastor, nada me falta.',
                'verse_reference': 'Salmo 23:1',
                'prayer': 'Señor, guíame en tu paz.',
                'explanation': 'Este verso te recuerda que Dios cuida de ti.',
              }),
            },
          },
        ],
      });

      // Use utf8 bytes so that utf8.decode(response.bodyBytes) works
      final responseBytes = utf8.encode(responseJson);

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response.bytes(responseBytes, 200));

      final verse = await aiService.getComfortingVerse('triste', 'Triste');

      expect(verse, isNotNull);
      expect(verse!.text, 'El Señor es mi pastor, nada me falta.');
      expect(verse.reference, 'Salmo 23:1');
      expect(verse.prayer, contains('Señor, guíame en tu paz'));
    });

    test('returns null on API error (500)', () async {
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Server Error', 500));

      final verse = await aiService.getComfortingVerse('ansioso', 'Ansioso');

      expect(verse, isNull);
    });

    test('returns null on network exception', () async {
      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenThrow(Exception('No internet'));

      final verse = await aiService.getComfortingVerse('cansado', 'Cansado');

      expect(verse, isNull);
    });
  });
}
