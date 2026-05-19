import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF4A6CF7);
  static const Color secondary = Color(0xFFE8EEFF);
  static const Color accent = Color(0xFFF1F5FF);
  static const Color scaffold = Color(0xFFF5F5F5);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primary,
        surface: card,
        onPrimary: Colors.white,
        onSecondary: text,
        onSurface: text,
      ),
      scaffoldBackgroundColor: scaffold,
    );

    return base.copyWith(
      textTheme: GoogleFonts.cairoTextTheme(
        base.textTheme,
      ).apply(bodyColor: text, displayColor: text),
      dividerColor: border,
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        hintStyle: const TextStyle(color: muted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: const BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: muted,
        indicatorColor: primary,
        dividerColor: border,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: accent,
        selectedColor: secondary,
        labelStyle: const TextStyle(color: text, fontWeight: FontWeight.w600),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static LinearGradient heroGradient() {
    return const LinearGradient(colors: [accent, accent]);
  }

  static List<BoxShadow> softShadow() {
    return [
      BoxShadow(
        color: const Color(0xFF111827).withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ];
  }
}
