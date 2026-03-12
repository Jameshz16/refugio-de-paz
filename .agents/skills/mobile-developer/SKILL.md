---
name: mobile-developer
description: Expert in Flutter, Dart, and cross-platform mobile development architecture
version: 1.1.0
tags: [mobile, flutter, dart, ios, android, cross-platform, architecture]
---

# Mobile Developer Skill (Flutter Edition)

I help you build scalable and well-architected cross-platform mobile apps using Flutter.

## Architecture & Separation of Concerns

A clean architecture is essential for maintainable Flutter apps. I enforce the separation of UI, business logic, and data services.

### Recommended Project Structure

```text
lib/
├── core/                  # App-wide constants, themes, and utilities
│   ├── constants.dart
│   ├── theme.dart
│   └── errors.dart
├── models/                # Data models and entities
│   └── user.dart
├── services/              # External APIs, local storage, native capabilities
│   ├── api_service.dart
│   └── storage_service.dart
├── providers/             # State management (Provider, Riverpod, BLoC)
│   └── auth_provider.dart
├── ui/                    # UI elements separated by screens and shared widgets
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── login_screen.dart
│   └── widgets/           # Reusable components
│       ├── custom_button.dart
│       └── info_card.dart
└── main.dart              # Entry point and dependency injection
```

---

## State Management

Decouple your business logic from your UI. Here is an example using `Provider`:

### 1. The Provider (Business Logic)

```dart
// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  User? _user;
  bool _isLoading = false;

  AuthProvider(this._apiService);

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _apiService.authenticate(email, password);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 2. The UI (View)

```dart
// lib/ui/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: authProvider.isLoading
            ? CircularProgressIndicator()
            : CustomButton(
                text: 'Login',
                onPressed: () => authProvider.login('test@test.com', 'password'),
              ),
      ),
    );
  }
}
```

---

## Services & Data Fetching

Keep API calls and external data fetching out of your UI and State Management files.

### API Service Example

```dart
// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  final String baseUrl = 'https://api.example.com';

  Future<User> authenticate(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to authenticate');
    }
  }
}
```

---

## Navigation

Use a robust routing solution like `go_router` for deep linking and predictable navigation.

```dart
// lib/core/router.dart
import 'package:go_router/go_router.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/login_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
```

---

## UI Components

Build reusable, customized components that map to your design system.

### Custom Button

```dart
// lib/ui/widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}
```

---

## Native Features Integration

Abstract native capabilities into services so they can be easily mocked during testing.

### Location Service

```dart
// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
```

---

## Performance Rules

- **Use `const` constructors:** Always use `const` for widgets that don’t change to prevent unnecessary rebuilds.
- **Isolates / Compute:** Move heavy json parsing or computations to background threads using `compute()`.
- **List Optimization:** Use `ListView.builder` or `SliverList` instead of a plain `ListView` or `SingleChildScrollView` for long lists to leverage lazy rendering.
- **Image Caching:** Use packages like `cached_network_image` to avoid re-downloading images.

---

## When to Use Me

**Perfect for:**

- Structuring new Flutter projects.
- Refactoring messy spaghetti code into clean architecture.
- Implementing state management accurately.
- Isolating UI from business logic and backend services.

**I'll help you:**

- Build scalable Flutter architectures.
- Set up secure and robust Data/Service layers.
- Optimize widgets and app performance.
