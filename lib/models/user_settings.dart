/// User settings model for app configuration and personalization.
class UserSettings {
  final String userName;
  final String themeMode; // 'light', 'dark', 'system'
  final String fontFamily; // 'Lexend', 'Caveat', 'Dancing Script'
  final double fontScale; // 0.85, 1.0, 1.15
  final bool notificationsEnabled;
  final int notificationHour;
  final bool hapticFeedbackEnabled;
  final bool showEmotionChart;
  final bool isPremium; // true if the user purchased premium
  final String themeName; // 'cream', 'sunrise', 'forest', 'night', 'spring'

  const UserSettings({
    this.userName = '',
    this.themeMode = 'system',
    this.fontFamily = 'Lexend',
    this.fontScale = 1.0,
    this.notificationsEnabled = true,
    this.notificationHour = 9,
    this.hapticFeedbackEnabled = true,
    this.showEmotionChart = true,
    this.isPremium = false,
    this.themeName = 'cream',
  });

  UserSettings copyWith({
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
    return UserSettings(
      userName: userName ?? this.userName,
      themeMode: themeMode ?? this.themeMode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontScale: fontScale ?? this.fontScale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      showEmotionChart: showEmotionChart ?? this.showEmotionChart,
      isPremium: isPremium ?? this.isPremium,
      themeName: themeName ?? this.themeName,
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'themeMode': themeMode,
    'fontFamily': fontFamily,
    'fontScale': fontScale,
    'notificationsEnabled': notificationsEnabled,
    'notificationHour': notificationHour,
    'hapticFeedbackEnabled': hapticFeedbackEnabled,
    'showEmotionChart': showEmotionChart,
    'isPremium': isPremium,
    'themeName': themeName,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userName: json['userName'] as String? ?? '',
      themeMode: json['themeMode'] as String? ?? 'system',
      fontFamily: json['fontFamily'] as String? ?? 'Lexend',
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notificationHour: json['notificationHour'] as int? ?? 9,
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool? ?? true,
      showEmotionChart: json['showEmotionChart'] as bool? ?? true,
      isPremium: json['isPremium'] as bool? ?? false,
      themeName: json['themeName'] as String? ?? 'cream',
    );
  }
}
