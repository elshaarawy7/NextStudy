import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF6F6CFF);
  static const Color secondary = Color(0xFF56CCF2);
  static const Color scaffold = Color(0xFFF6F7FB);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1E2442);
  static const Color muted = Color(0xFF7A8097);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scaffold,
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(bodyColor: text, displayColor: text),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: primary.withValues(alpha: 0.08),
        selectedColor: primary.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: text, fontWeight: FontWeight.w600),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static LinearGradient heroGradient() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7C6CFF), Color(0xFF5C85FF), Color(0xFF5DD6FF)],
    );
  }

  static List<BoxShadow> softShadow() {
    return [
      BoxShadow(
        color: const Color(0xFFB2B8D7).withValues(alpha: 0.18),
        blurRadius: 30,
        offset: const Offset(0, 16),
      ),
    ];
  }
}
