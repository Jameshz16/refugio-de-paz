import 'package:flutter_test/flutter_test.dart';
import 'package:refugio_de_paz/models/verse.dart';
import 'package:refugio_de_paz/services/ai_service.dart';

void main() {
  // Smoke test: verify AIService can be instantiated
  test('AIService can be created', () {
    final service = AIService();
    expect(service, isNotNull);
  });

  // Verify Verse model round-trip (this doesn't need network)
  test('Verse round-trip JSON serialization', () {
    final original = Verse(
      text: 'Confía en el Señor',
      reference: 'Proverbios 3:5',
      date: DateTime(2026, 3, 2),
      prayer: 'Una oración',
      isFavorite: true,
    );

    final json = original.toJson();
    final restored = Verse.fromJson(json);

    expect(restored.text, original.text);
    expect(restored.reference, original.reference);
    expect(restored.prayer, original.prayer);
    expect(restored.isFavorite, original.isFavorite);
  });
}
