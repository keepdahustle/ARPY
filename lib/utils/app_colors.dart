import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDarkBlue = Color(0xFF516D83);
  static const Color primaryLightBlue = Color(0xFF9CB4C3);
  static const Color secondaryLightBlue = Color(0xFF97B4E6);
  
  // Background & Surface Colors
  static const Color backgroundWhite = Color(0xFFFCFCFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFDCE4EC);
  static const Color mediumGrey = Color(0xFF959595);
  static const Color darkGrey = Color(0xFF666666);
  
  // Status Colors
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color errorLightRed = Color(0xFFFFE6E6);
  static const Color successGreen = Color(0xFF51CF66);
  static const Color successLightGreen = Color(0xFFE6F7E6);
  static const Color warningYellow = Color(0xFFFCC419);
  static const Color warningLightYellow = Color(0xFFFFF3CD);
  static const Color infoBlueBg = Color(0xFFE8F1FF);
  
  // Custom Colors (replacing green and orange with bluish-grey palette)
  static const Color primaryTeal = Color(0xFF5BA3A3);      // Terang, mirip primary blue
  static const Color primaryTealLight = Color(0xFFD0E8E8); // Light version
  static const Color secondaryIndigo = Color(0xFF6B7FA3);  // Lebih gelap, mirip secondary
  static const Color secondaryIndigoLight = Color(0xFFD8E0ED); // Light version
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9CB4C3), Color(0xFF97B4E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF51CF66), Color(0xFF40C057)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Text Colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
}
