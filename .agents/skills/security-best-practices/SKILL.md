---
name: security-best-practices
description: "Mobile security best practices for Flutter apps. Covers secure storage, API key management, SSL pinning, biometric auth, code obfuscation, and data encryption. Use when handling sensitive data, auth tokens, or preparing for production."
version: 1.0.0
tags: [security, flutter, encryption, auth, storage, ssl-pinning]
---

# Security Best Practices for Flutter

> **Rule:** Treat every user's data as if it were your own. Protect it accordingly.

---

## 1. Secure Storage (Never Use SharedPreferences for Secrets)

### Install

```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

### Implementation

```dart
// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // API Tokens
  static Future<void> saveToken(String token) =>
      _storage.write(key: 'auth_token', value: token);

  static Future<String?> getToken() =>
      _storage.read(key: 'auth_token');

  static Future<void> deleteToken() =>
      _storage.delete(key: 'auth_token');

  // Clear all on logout
  static Future<void> clearAll() => _storage.deleteAll();
}
```

### What Goes Where

| Data             | Storage                  | Why                         |
| ---------------- | ------------------------ | --------------------------- |
| Auth tokens      | `flutter_secure_storage` | Encrypted keychain/keystore |
| API keys         | `--dart-define` env vars | Never in source code        |
| User preferences | `SharedPreferences`      | Not sensitive               |
| Diary entries    | Supabase + RLS           | Server-side protection      |
| Cached verses    | Local DB                 | Not sensitive               |

---

## 2. API Key Management

### ❌ NEVER hardcode keys

```dart
// BAD - Will be reverse-engineered
const apiKey = 'sk-abc123...';
```

### ✅ Use compile-time environment variables

```bash
# Run with secrets
flutter run --dart-define=DEEPSEEK_API_KEY=sk-abc123 --dart-define=SUPABASE_KEY=eyJ...
```

```dart
// lib/core/config.dart
class AppConfig {
  static const deepseekApiKey = String.fromEnvironment('DEEPSEEK_API_KEY');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
}
```

### ✅ Even better: use a backend proxy

Route API calls through your own backend so the AI key never reaches the client:

```
App → Your Backend (has DeepSeek key) → DeepSeek API
```

---

## 3. Biometric Authentication

### Install

```yaml
dependencies:
  local_auth: ^2.1.0
```

### Implementation

```dart
// lib/services/biometric_service.dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentícate para acceder a tu diario',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN fallback
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
```

### Use for Diary Access

```dart
// Before opening diary
final bioService = BiometricService();
if (await bioService.isAvailable()) {
  final authenticated = await bioService.authenticate();
  if (!authenticated) return; // Block access
}
Navigator.push(context, MaterialPageRoute(builder: (_) => DiaryScreen()));
```

---

## 4. SSL Pinning

```yaml
dependencies:
  http_certificate_pinning: ^2.0.0
```

```dart
// Verify server certificate matches expected hash
final client = HttpCertificatePinning(
  allowedSHAFingerprints: ['AB:CD:EF:12:34:...'],
);
```

---

## 5. Code Obfuscation (Release Builds)

```bash
# Android
flutter build apk --obfuscate --split-debug-info=./debug-info/

# iOS
flutter build ipa --obfuscate --split-debug-info=./debug-info/
```

> Keep `debug-info/` safe — you need it to symbolicate crash reports.

---

## 6. Supabase Row Level Security (RLS)

```sql
-- Users can only read their own diary entries
CREATE POLICY "Users read own entries" ON diary_entries
  FOR SELECT USING (auth.uid() = user_id);

-- Users can only insert their own entries
CREATE POLICY "Users insert own entries" ON diary_entries
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

> ⚠️ **ALWAYS enable RLS on every table that contains user data.**

---

## 7. Security Checklist

- [ ] No hardcoded API keys in source code
- [ ] Tokens stored in `flutter_secure_storage`
- [ ] Biometric lock on sensitive screens (diary)
- [ ] RLS enabled on all Supabase tables
- [ ] Code obfuscated in release builds
- [ ] HTTPS enforced on all API calls
- [ ] No sensitive data in logs
- [ ] `debug-info/` excluded from git

---

## Anti-Patterns

| ❌ Never                            | ✅ Always                            |
| ----------------------------------- | ------------------------------------ |
| Store tokens in `SharedPreferences` | Use `flutter_secure_storage`         |
| Hardcode API keys                   | Use `--dart-define` or backend proxy |
| Log user passwords/tokens           | Redact all PII                       |
| Ship without obfuscation            | `--obfuscate` on release             |
| Skip RLS                            | Enable on every table                |

---

## When to Use

Apply this skill from day one, especially before any production release. Review the checklist before every store submission.
