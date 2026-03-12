import 'package:flutter_test/flutter_test.dart';
import 'package:refugio_de_paz/models/verse.dart';

void main() {
  group('Verse Model', () {
    test('creates with required fields', () {
      final verse = Verse(
        text: 'El Señor es mi pastor',
        reference: 'Salmo 23:1',
        date: DateTime(2026, 3, 2),
      );

      expect(verse.text, 'El Señor es mi pastor');
      expect(verse.reference, 'Salmo 23:1');
      expect(verse.date, DateTime(2026, 3, 2));
    });

    test('isFavorite defaults to false', () {
      final verse = Verse(
        text: 'Test',
        reference: 'Test 1:1',
        date: DateTime.now(),
      );

      expect(verse.isFavorite, false);
    });

    test('prayer is optional', () {
      final verse = Verse(
        text: 'Test',
        reference: 'Test 1:1',
        date: DateTime.now(),
      );

      expect(verse.prayer, isNull);
    });

    test('toJson produces correct map', () {
      final date = DateTime(2026, 3, 2);
      final verse = Verse(
        text: 'Confía en el Señor',
        reference: 'Proverbios 3:5',
        date: date,
        prayer: 'Una oración',
        isFavorite: true,
      );

      final json = verse.toJson();

      expect(json['text'], 'Confía en el Señor');
      expect(json['reference'], 'Proverbios 3:5');
      expect(json['date'], date.toIso8601String());
      expect(json['prayer'], 'Una oración');
      expect(json['isFavorite'], true);
    });

    test('fromJson creates Verse correctly', () {
      final json = {
        'text': 'Salmo 23:1',
        'reference': 'Salmo 23:1',
        'date': '2026-03-02T00:00:00.000',
        'prayer': 'Oración de paz',
        'isFavorite': true,
      };

      final verse = Verse.fromJson(json);

      expect(verse.text, 'Salmo 23:1');
      expect(verse.reference, 'Salmo 23:1');
      expect(verse.prayer, 'Oración de paz');
      expect(verse.isFavorite, true);
    });

    test('fromJson handles missing optional fields', () {
      final json = {
        'text': 'Test',
        'reference': 'Test 1:1',
        'date': '2026-03-02T00:00:00.000',
      };

      final verse = Verse.fromJson(json);

      expect(verse.prayer, isNull);
      expect(verse.isFavorite, false);
    });
  });
}
