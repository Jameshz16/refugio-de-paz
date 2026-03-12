import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App-wide configuration.
/// All secrets are injected via .env file or --dart-define.
class AppConfig {
  static String get deepseekApiKey =>
      dotenv.env['DEEPSEEK_API_KEY'] ?? const String.fromEnvironment('DEEPSEEK_API_KEY');

  static const String deepseekApiUrl = 'https://api.deepseek.com/chat/completions';

  // RevenueCat
  static String get revenueCatApiKey =>
      dotenv.env['REVENUECAT_API_KEY'] ?? const String.fromEnvironment('REVENUECAT_API_KEY');

  // Google Sign-In OAuth
  static String get googleWebClientId => dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? const String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  static String get googleIosClientId => dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? const String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
}
