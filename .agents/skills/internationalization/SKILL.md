---
name: internationalization
description: "Internationalization (i18n) and localization (l10n) for Flutter apps. Covers flutter_localizations, ARB files, multi-language support, RTL layouts, date/number formatting, and dynamic locale switching."
version: 1.0.0
tags: [i18n, l10n, localization, internationalization, flutter, multi-language]
---

# Internationalization (i18n) for Flutter

> **Rule:** Build for your first language, but architect for all languages.

---

## 1. Setup

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0

flutter:
  generate: true # Enable code generation
```

### l10n.yaml (project root)

```yaml
arb-dir: lib/l10n
template-arb-file: app_es.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
preferred-supported-locales: [es]
```

---

## 2. ARB Translation Files

### Spanish (Primary) — `lib/l10n/app_es.arb`

```json
{
  "@@locale": "es",
  "appTitle": "Refugio de Paz",
  "howDoYouFeel": "¿Cómo te sientes hoy?",
  "talkToGod": "Hablar con Dios",
  "searchingComfort": "Buscando aliento...",
  "tellGod": "Cuéntale a Dios...",
  "whatToSayToGod": "¿Qué tienes para decirle a Dios hoy?",
  "savedToFavorites": "Guardado en tus favoritos ✨",
  "errorGettingVerse": "Hubo un error al buscar aliento. Intenta nuevamente.",
  "myDiary": "Mi Diario",
  "wordsOfEncouragement": "Palabras de aliento y Oración",
  "youFeel": "Te sientes {emotion}",
  "@youFeel": {
    "placeholders": {
      "emotion": { "type": "String" }
    }
  },
  "emotionHappy": "Feliz",
  "emotionSad": "Triste",
  "emotionAnxious": "Ansioso",
  "emotionGrateful": "Agradecido",
  "emotionTired": "Cansado",
  "emotionFearful": "Temeroso"
}
```

### English — `lib/l10n/app_en.arb`

```json
{
  "@@locale": "en",
  "appTitle": "Refuge of Peace",
  "howDoYouFeel": "How are you feeling today?",
  "talkToGod": "Talk to God",
  "searchingComfort": "Searching for comfort...",
  "tellGod": "Tell God...",
  "whatToSayToGod": "What would you like to say to God today?",
  "savedToFavorites": "Saved to your favorites ✨",
  "errorGettingVerse": "There was an error finding comfort. Please try again.",
  "myDiary": "My Diary",
  "wordsOfEncouragement": "Words of Encouragement and Prayer",
  "youFeel": "You're feeling {emotion}",
  "emotionHappy": "Happy",
  "emotionSad": "Sad",
  "emotionAnxious": "Anxious",
  "emotionGrateful": "Grateful",
  "emotionTired": "Tired",
  "emotionFearful": "Fearful"
}
```

---

## 3. Configure MaterialApp

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RefugioDePazApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),  // Spanish (primary)
        Locale('en'),  // English
      ],
      locale: const Locale('es'), // Default
      home: const HomeScreen(),
    );
  }
}
```

---

## 4. Usage in Widgets

```dart
// Before (hardcoded)
Text('¿Cómo te sientes hoy?')

// After (localized)
Text(AppLocalizations.of(context)!.howDoYouFeel)

// With parameters
Text(AppLocalizations.of(context)!.youFeel('Feliz'))
```

### Generate Code

```bash
flutter gen-l10n
```

---

## 5. Date & Number Formatting

```dart
import 'package:intl/intl.dart';

// Dates respect locale
final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).languageCode);
Text(dateFormat.format(DateTime.now())); // "2 mar 2026" (es) / "Mar 2, 2026" (en)

// Numbers
final numberFormat = NumberFormat.compact(locale: 'es');
Text(numberFormat.format(1500)); // "1,5 mil"
```

---

## 6. Dynamic Locale Switching

```dart
class RefugioDePazApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_RefugioDePazAppState>()!._setLocale(locale);
  }

  @override
  State<RefugioDePazApp> createState() => _RefugioDePazAppState();
}

class _RefugioDePazAppState extends State<RefugioDePazApp> {
  Locale _locale = const Locale('es');

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      // ... delegates and supported locales
    );
  }
}

// In settings screen:
DropdownButton<Locale>(
  value: currentLocale,
  items: const [
    DropdownMenuItem(value: Locale('es'), child: Text('Español')),
    DropdownMenuItem(value: Locale('en'), child: Text('English')),
  ],
  onChanged: (locale) {
    if (locale != null) RefugioDePazApp.setLocale(context, locale);
  },
)
```

---

## 7. Anti-Patterns

| ❌ Never                          | ✅ Always                   |
| --------------------------------- | --------------------------- |
| Hardcode strings in widgets       | Use ARB files               |
| Concatenate strings for sentences | Use placeholders `{name}`   |
| Assume text length                | Design for 30-40% expansion |
| Hardcode date formats             | Use `intl` package          |
| Forget RTL languages              | Test with RTL locales       |

---

## 8. Checklist

- [ ] ARB file created for primary language
- [ ] All user-facing strings extracted
- [ ] `flutter gen-l10n` runs without errors
- [ ] Placeholders used for dynamic content
- [ ] Dates and numbers use `intl` formatting
- [ ] Layout tested with longer translations (German, Portuguese)
- [ ] RTL layout verified (if supporting Arabic/Hebrew)

---

## When to Use

Start extracting strings **from day one**, even if you only support one language. Adding i18n later is exponentially harder.
