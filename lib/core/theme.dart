import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF004D40); // Dark Green
  static const Color primaryDark = Color(0xFF00251A);
  static const Color primaryLight = Color(0xFF39796B);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF333333);
  static const Color textLight = Color(0xFF9E9E9E);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryDark,
        surface: surfaceColor,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 16,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: textLight,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.inter(color: textLight),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),
    );
  }
}
