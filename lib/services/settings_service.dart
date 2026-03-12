import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

/// Service that persists user settings to SharedPreferences
/// and notifies listeners when settings change.
class SettingsService extends ChangeNotifier {
  static const String _settingsKey = 'user_settings';

  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  UserSettings _settings = const UserSettings();
  bool _initialized = false;

  UserSettings get settings => _settings;
  bool get initialized => _initialized;

  /// Load settings from disk. Call once at app startup.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_settingsKey);
    if (jsonStr != null) {
      try {
        _settings = UserSettings.fromJson(jsonDecode(jsonStr));
      } catch (_) {
        _settings = const UserSettings();
      }
    }
    _initialized = true;
    notifyListeners();
  }

  /// Update settings and persist to disk.
  Future<void> update(UserSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
  }

  /// Helper to update a single field.
  Future<void> updateWith({
    String? userName,
    String? themeMode,
    String? fontFamily,
    double? fontScale,
    bool? notificationsEnabled,
    int? notificationHour,
    bool? hapticFeedbackEnabled,
    bool? showEmotionChart,
    bool? isPremium,
    String? themeName,
  }) {
    return update(_settings.copyWith(
      userName: userName,
      themeMode: themeMode,
      fontFamily: fontFamily,
      fontScale: fontScale,
      notificationsEnabled: notificationsEnabled,
      notificationHour: notificationHour,
      hapticFeedbackEnabled: hapticFeedbackEnabled,
      showEmotionChart: showEmotionChart,
      isPremium: isPremium,
      themeName: themeName,
    ));
  }

  /// Get the Flutter ThemeMode from stored settings.
  ThemeMode get themeMode {
    switch (_settings.themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  /// Reset all settings to defaults.
  Future<void> resetAll() async {
    _settings = const UserSettings();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
  }

  /// Clear all app data (settings + favorites + diary + emotion history).
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _settings = const UserSettings();
    notifyListeners();
  }

  /// Clear emotion history only.
  Future<void> clearEmotionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emotion_history'); // Legacy
    await prefs.remove('emotion_drops_list');
  }
}
