import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const _primarySeed = Color(0xFF1A6B5A); // deep teal
  static const _secondarySeed = Color(0xFF6B5A9C); // soft indigo

  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      secondary: _secondarySeed,
      brightness: Brightness.light,
    );
    return _buildTheme(base);
  }

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      secondary: _secondarySeed,
      brightness: Brightness.dark,
    );
    return _buildTheme(base);
  }

  static ThemeData _buildTheme(ColorScheme scheme) {
    final textTheme = GoogleFonts.interTextTheme(ThemeData(
      colorScheme: scheme,
    ).textTheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: scheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Tag colors
  static Color tagColor(String tag, {bool dark = false}) {
    switch (tag) {
      case 'Focus':
        return dark ? const Color(0xFF1E4D8C) : const Color(0xFFDEEAFF);
      case 'Calm':
        return dark ? const Color(0xFF1A5C3D) : const Color(0xFFD9F5E8);
      case 'Sleep':
        return dark ? const Color(0xFF3D2970) : const Color(0xFFEAE0FF);
      case 'Reset':
        return dark ? const Color(0xFF6B3A1A) : const Color(0xFFFFEEDE);
      default:
        return dark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0);
    }
  }

  static Color tagTextColor(String tag) {
    switch (tag) {
      case 'Focus':
        return const Color(0xFF1E4D8C);
      case 'Calm':
        return const Color(0xFF1A5C3D);
      case 'Sleep':
        return const Color(0xFF6B3A99);
      case 'Reset':
        return const Color(0xFF8B4A1A);
      default:
        return const Color(0xFF4A4A4A);
    }
  }
}
