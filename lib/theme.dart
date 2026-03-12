import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CozyPalette extends ThemeExtension<CozyPalette> {
  final Color background;
  final Color surface;
  final Color primary;
  final Color accent;
  final Color pastel;
  final Color textDark;
  final Color textLight;

  const CozyPalette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.accent,
    required this.pastel,
    required this.textDark,
    required this.textLight,
  });

  @override
  ThemeExtension<CozyPalette> copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? accent,
    Color? pastel,
    Color? textDark,
    Color? textLight,
  }) {
    return CozyPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      pastel: pastel ?? this.pastel,
      textDark: textDark ?? this.textDark,
      textLight: textLight ?? this.textLight,
    );
  }

  @override
  ThemeExtension<CozyPalette> lerp(ThemeExtension<CozyPalette>? other, double t) {
    if (other is! CozyPalette) return this;
    return CozyPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      pastel: Color.lerp(pastel, other.pastel, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textLight: Color.lerp(textLight, other.textLight, t)!,
    );
  }

  static const cream = CozyPalette(
    background: Color(0xFFFDFCF0),
    surface: Colors.white,
    primary: Color(0xFFE3F2FD),
    accent: Color(0xFF1976D2),
    pastel: Color(0xFFFCE4EC),
    textDark: Color(0xFF263238),
    textLight: Color(0xFF546E7A),
  );

  static const sunrise = CozyPalette(
    background: Color(0xFFFFF8E1),
    surface: Colors.white,
    primary: Color(0xFFFFECB3),
    accent: Color(0xFFF57C00),
    pastel: Color(0xFFFFE0B2),
    textDark: Color(0xFF3E2723),
    textLight: Color(0xFF5D4037),
  );

  static const forest = CozyPalette(
    background: Color(0xFFF1F8E9),
    surface: Colors.white,
    primary: Color(0xFFDCEDC8),
    accent: Color(0xFF33691E),
    pastel: Color(0xFFD7CCC8),
    textDark: Color(0xFF1B5E20),
    textLight: Color(0xFF388E3C),
  );

  static const night = CozyPalette(
    background: Color(0xFFEDE7F6),
    surface: Colors.white,
    primary: Color(0xFFD1C4E9),
    accent: Color(0xFF311B92),
    pastel: Color(0xFFC5CAE9),
    textDark: Color(0xFF1A237E),
    textLight: Color(0xFF3949AB),
  );

  static const spring = CozyPalette(
    background: Color(0xFFFCE4EC),
    surface: Colors.white,
    primary: Color(0xFFF8BBD0),
    accent: Color(0xFFC2185B),
    pastel: Color(0xFFE1BEE7),
    textDark: Color(0xFF880E4F),
    textLight: Color(0xFFAD1457),
  );

  static CozyPalette getPalette(String themeName) {
    switch (themeName) {
      case 'sunrise': return sunrise;
      case 'forest': return forest;
      case 'night': return night;
      case 'spring': return spring;
      case 'cream':
      default: return cream;
    }
  }

  static CozyPalette getDarkPalette(String themeName) {
    final base = getPalette(themeName);
    return CozyPalette(
      background: const Color(0xFF1A1A2E),
      surface: const Color(0xFF1F2B47),
      primary: Color.lerp(base.primary, const Color(0xFF1F2B47), 0.4)!,
      accent: Color.lerp(base.accent, Colors.white, 0.4)!,
      pastel: Color.lerp(base.pastel, const Color(0xFF1F2B47), 0.4)!,
      textDark: const Color(0xFFE8E8E8),
      textLight: const Color(0xFFD1D5DB),
    );
  }
}

extension CozyThemeExt on BuildContext {
  CozyPalette get cozy => Theme.of(this).extension<CozyPalette>() ?? CozyPalette.cream;
}

class CozyTheme {
  static const Color cream = Color(0xFFFDFCF0);
  static const Color softBlue = Color(0xFFE3F2FD);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color pastelPink = Color(0xFFFCE4EC);
  static const Color textDark = Color(0xFF263238);
  static const Color textLight = Color(0xFF546E7A);

  // Dark theme colors
  static const Color darkBg = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkCard = Color(0xFF1F2B47);
  static const Color darkAccent = Color(0xFF7EC8E3);
  static const Color darkPink = Color(0xFFE8A0BF);
  static const Color darkTextPrimary = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);

  /// Create a TextTheme from a font family name and scale.
  static TextTheme _buildTextTheme(String fontFamily, double scale) {
    TextTheme Function() fontBuilder;

    switch (fontFamily) {
      case 'Caveat':
        fontBuilder = GoogleFonts.caveatTextTheme;
        break;
      case 'Dancing Script':
        fontBuilder = GoogleFonts.dancingScriptTextTheme;
        break;
      case 'Lexend':
      default:
        fontBuilder = GoogleFonts.lexendTextTheme;
        break;
    }

    final base = fontBuilder();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 32 * scale,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24 * scale,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22 * scale,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18 * scale,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 16 * scale,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 18 * scale,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 16 * scale,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 14 * scale,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 16 * scale,
      ),
    );
  }

  /// Light theme with configurable font and scale.
  static ThemeData lightTheme({
    String fontFamily = 'Lexend',
    double fontScale = 1.0,
    String themeName = 'cream',
  }) {
    final textTheme = _buildTextTheme(fontFamily, fontScale);
    final palette = CozyPalette.getPalette(themeName);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: [palette],
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: Brightness.light,
        surface: palette.surface,
      ),
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme.apply(
        bodyColor: palette.textDark,
        displayColor: palette.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: palette.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: palette.textDark),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.accent;
          return palette.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent.withOpacity(0.5);
          }
          return palette.textLight.withOpacity(0.2);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: palette.textLight.withOpacity(0.15),
        thickness: 1,
      ),
    );
  }

  /// Dark theme with configurable font and scale.
  static ThemeData darkTheme({
    String fontFamily = 'Lexend',
    double fontScale = 1.0,
    String themeName = 'cream',
  }) {
    final textTheme = _buildTextTheme(fontFamily, fontScale);
    final palette = CozyPalette.getDarkPalette(themeName);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: [palette],
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: Brightness.dark,
        surface: palette.surface,
      ),
      scaffoldBackgroundColor: palette.background,
      textTheme: textTheme.apply(
        bodyColor: palette.textDark,
        displayColor: palette.textDark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: palette.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: palette.textDark),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.accent;
          return palette.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.accent.withOpacity(0.4);
          }
          return palette.textLight.withOpacity(0.2);
        }),
      ),
      dividerTheme: DividerThemeData(
        color: palette.textLight.withOpacity(0.15),
        thickness: 1,
      ),
    );
  }
}
