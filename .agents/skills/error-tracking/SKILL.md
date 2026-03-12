---
name: error-tracking
description: "Production error tracking and crash reporting for Flutter apps. Covers Sentry integration, Firebase Crashlytics, structured logging, and performance monitoring. Use when setting up production monitoring or debugging prod issues."
version: 1.0.0
tags: [error-tracking, sentry, crashlytics, logging, monitoring, flutter]
---

# Error Tracking & Monitoring for Flutter

> **Rule:** If you can't see it crash, you can't fix it.

---

## 1. Choose Your Tool

| Tool                     | Best For                                           | Free Tier      |
| ------------------------ | -------------------------------------------------- | -------------- |
| **Sentry**               | Cross-platform, detailed stack traces, breadcrumbs | 5K events/mo   |
| **Firebase Crashlytics** | Google ecosystem, simple setup                     | Unlimited      |
| **Both**                 | Maximum coverage                                   | ✅ Recommended |

---

## 2. Sentry Integration

### Install

```yaml
# pubspec.yaml
dependencies:
  sentry_flutter: ^7.0.0
```

### Initialize

```dart
// lib/main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.environment = const String.fromEnvironment(
        'ENV',
        defaultValue: 'development',
      );
      options.tracesSampleRate = 0.2; // 20% of transactions
      options.attachScreenshot = true;
      options.reportPackages = false;
    },
    appRunner: () => runApp(
      SentryNavigatorObserver(), // Track navigation
      const RefugioDePazApp(),
    ),
  );
}
```

### Capture Errors

```dart
// Automatic: uncaught exceptions are captured by default

// Manual capture
try {
  await aiService.getComfortingVerse(feeling, emotion);
} catch (exception, stackTrace) {
  await Sentry.captureException(
    exception,
    stackTrace: stackTrace,
    hint: Hint.withMap({
      'emotion': emotion,
      'feeling_length': feeling.length.toString(),
    }),
  );
}
```

### Breadcrumbs (User Journey)

```dart
Sentry.addBreadcrumb(Breadcrumb(
  message: 'User selected emotion',
  category: 'user.action',
  data: {'emotion': 'Feliz'},
));
```

---

## 3. Firebase Crashlytics

### Install

```yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_crashlytics: ^3.0.0
```

### Initialize

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Catch Flutter framework errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const RefugioDePazApp());
}
```

---

## 4. Structured Logging Service

```dart
// lib/services/logger_service.dart
import 'package:sentry_flutter/sentry_flutter.dart';

enum LogLevel { debug, info, warning, error }

class LoggerService {
  static void log(
    String message, {
    LogLevel level = LogLevel.info,
    Map<String, dynamic>? data,
  }) {
    // Development: print to console
    assert(() {
      print('[${level.name.toUpperCase()}] $message ${data ?? ""}');
      return true;
    }());

    // Production: send breadcrumb to Sentry
    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      level: _toSentryLevel(level),
      data: data,
      timestamp: DateTime.now(),
    ));
  }

  static SentryLevel _toSentryLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug: return SentryLevel.debug;
      case LogLevel.info: return SentryLevel.info;
      case LogLevel.warning: return SentryLevel.warning;
      case LogLevel.error: return SentryLevel.error;
    }
  }
}
```

### Usage

```dart
LoggerService.log('Verso generado exitosamente', data: {'emotion': 'Feliz'});
LoggerService.log('API timeout', level: LogLevel.warning);
```

---

## 5. Performance Monitoring

```dart
// Track slow operations
final transaction = Sentry.startTransaction('ai_verse', 'task');
try {
  final verse = await aiService.getComfortingVerse(feeling, emotion);
  transaction.status = const SpanStatus.ok();
} catch (e) {
  transaction.status = const SpanStatus.internalError();
} finally {
  await transaction.finish();
}
```

---

## 6. Anti-Patterns

| ❌ Never                | ✅ Always                    |
| ----------------------- | ---------------------------- |
| `print()` in production | Use `LoggerService`          |
| Log passwords/tokens    | Redact sensitive data        |
| Ignore crash reports    | Triage weekly                |
| Hardcode DSN keys       | Use `--dart-define` env vars |
| Track everything (100%) | Sample transactions (10-20%) |

---

## When to Use

Apply this skill when setting up a new project for production, debugging live issues, or reviewing crash reports. Every release should have error tracking enabled.
