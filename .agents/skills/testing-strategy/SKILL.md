---
name: testing-strategy
description: "Comprehensive testing strategy for Flutter apps. Covers unit tests, widget tests, integration tests, mocking with Mocktail, golden tests, and CI test automation. Tailored for Flutter + Supabase + AI-driven apps."
version: 1.0.0
tags: [testing, flutter, unit-test, widget-test, integration-test, tdd]
---

# Testing Strategy for Flutter

> **Rule:** If it's not tested, it's not production-ready.

## Testing Pyramid

```
        ╔═══════════════╗
        ║  Integration  ║  ← Few (E2E flows)
        ╠═══════════════╣
        ║  Widget Tests ║  ← Many (UI behavior)
        ╠═══════════════╣
        ║  Unit Tests   ║  ← Most (logic, services)
        ╚═══════════════╝
```

**Minimum Coverage Targets:**

- Unit tests: **80%+** of models, services, providers
- Widget tests: All **critical screens** and **reusable components**
- Integration tests: **Core user flows** (login, main action, navigation)

---

## 1. Unit Tests (Models & Services)

### Testing a Model

```dart
// test/models/verse_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:refugio_de_paz/models/verse.dart';

void main() {
  group('Verse Model', () {
    test('creates from JSON correctly', () {
      final json = {
        'text': 'Salmo 23:1',
        'reference': 'Salmo 23:1',
        'prayer': 'Una oración de paz',
      };
      final verse = Verse.fromJson(json);

      expect(verse.text, 'Salmo 23:1');
      expect(verse.reference, 'Salmo 23:1');
      expect(verse.prayer, 'Una oración de paz');
    });

    test('isFavorite defaults to false', () {
      final verse = Verse(text: 'Test', reference: 'Ref');
      expect(verse.isFavorite, false);
    });
  });
}
```

### Testing a Service with Mocking

```dart
// test/services/ai_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:refugio_de_paz/services/ai_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late AIService aiService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    aiService = AIService(client: mockClient);
  });

  group('AIService', () {
    test('returns verse on success', () async {
      when(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(
        '{"choices":[{"message":{"content":"Salmo 23:1\\nEl Señor es mi pastor"}}]}',
        200,
      ));

      final verse = await aiService.getComfortingVerse('triste', 'Triste');

      expect(verse, isNotNull);
      expect(verse!.text, isNotEmpty);
    });

    test('returns null on API error', () async {
      when(() => mockClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      final verse = await aiService.getComfortingVerse('triste', 'Triste');

      expect(verse, isNull);
    });
  });
}
```

---

## 2. Widget Tests

### Testing a Screen

```dart
// test/screens/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:refugio_de_paz/main.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('shows emotion selection on load', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      expect(find.text('¿Cómo te sientes hoy?'), findsOneWidget);
      expect(find.text('😊'), findsOneWidget);
      expect(find.text('Feliz'), findsOneWidget);
    });

    testWidgets('navigates to phase 2 on emotion tap', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      await tester.tap(find.text('😊'));
      await tester.pumpAndSettle();

      expect(find.text('¿Qué tienes para decirle a Dios hoy?'), findsOneWidget);
    });
  });
}
```

---

## 3. Integration Tests

### Full Flow Test

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:refugio_de_paz/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete emotion to verse flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Phase 1: Select emotion
    await tester.tap(find.text('😊'));
    await tester.pumpAndSettle();

    // Phase 2: Write to God
    await tester.enterText(
      find.byType(TextField),
      'Gracias por este día',
    );
    await tester.tap(find.text('Hablar con Dios'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify verse appeared
    expect(find.byIcon(Icons.format_quote_rounded), findsOneWidget);
  });
}
```

---

## 4. Mocking Dependencies (Mocktail)

### pubspec.yaml

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
  integration_test:
    sdk: flutter
```

### Mock Pattern

```dart
// test/mocks.dart
import 'package:mocktail/mocktail.dart';
import 'package:refugio_de_paz/services/ai_service.dart';
import 'package:refugio_de_paz/services/storage_service.dart';

class MockAIService extends Mock implements AIService {}
class MockStorageService extends Mock implements StorageService {}
```

---

## 5. Running Tests

```bash
# Run all unit/widget tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Run a specific test file
flutter test test/models/verse_test.dart
```

---

## 6. Anti-Patterns

| ❌ Never                     | ✅ Always                           |
| ---------------------------- | ----------------------------------- |
| Test implementation details  | Test **behavior**                   |
| Skip error cases             | Test **happy + sad paths**          |
| Mock everything              | Only mock **external dependencies** |
| Write tests after bugs ship  | Write tests **before or with** code |
| Use `print()` to debug tests | Use `expect()` with clear matchers  |

---

## When to Use

Apply this skill whenever writing new features, fixing bugs, or refactoring. Every PR should include tests for the changed code.
