import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF0F766E); // Teal 700
  static const Color primaryDark = Color(0xFF042F2E);
  static const Color primaryLight = Color(0xFF14B8A6);

  // Light Colors
  static const Color lightBg = Color(0xFFF3F4F6);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Colors
  static const Color darkBg = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBg,
      cardColor: lightSurface,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryLight,
        surface: lightSurface,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: lightText,
        displayColor: lightText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: lightText),
        titleTextStyle: GoogleFonts.inter(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: lightTextSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: lightTextSecondary),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: darkBg,
      cardColor: darkSurface,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        secondary: primaryColor,
        surface: darkSurface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: darkText,
        displayColor: darkText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: darkText),
        titleTextStyle: GoogleFonts.inter(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryLight, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: darkTextSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: darkTextSecondary),
      ),
    );
  }
}
