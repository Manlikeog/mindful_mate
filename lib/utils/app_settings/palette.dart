import 'package:flutter/material.dart';

class Palette {
  // Primary Colors
  final Color primaryColor = const Color(0xFF2AB7CA);       // Calming teal
  final Color secondaryColor = const Color(0xFF9B5DE5);     // Soft purple
  final Color accentColor = const Color(0xFFFFD166);        // Warm gold

  // Neutral Colors
  final Color pureWhite = const Color(0xFFFFFFFF);
  final Color textColor = const Color(0xFF212121);          // Primary text
  final Color lightGray = const Color(0xFFF5F5F5);          // Backgrounds
  final Color dividerColor = const Color(0xFFEEEEEE);
  
  // Dark Mode Colors
  final Color darkModeBackground = const Color(0xFF121212); // Dark background
  final Color darkModeSurface = const Color(0xFF1F222A);    // Cards/dialogs
  final Color darkModeText = const Color(0xFFFFFFFF);

  // Interactive States
  final Color buttonSecColorDarkMode = const Color(0xFF35383F);
  final Color buttonSecColorLightMode = const Color(0xFFF0FBFA);
  final Color inactiveDotLightMode = const Color(0xFFE0E0E0);
  final Color inactiveDotDarkMode = const Color(0xFF757575);
  final Color inactiveTextfieldIconColor = const Color(0xFF9E9E9E);

  // Special Purpose
  final Color transparent = const Color(0x00000000);
  final Color strokeDark = const Color(0xFF35383F);
  final Color textFieldColorLightMode = const Color(0xFFFAFAFA);
  final Color textFieldColorDarkMode = const Color(0xFF1F222A);

  // Material Color Swatches
  MaterialColor kCustomPryColor = MaterialColor(0xFF2AB7CA, _tealSwatch);
  MaterialColor kCustomSECColor = MaterialColor(0xFF9B5DE5, _purpleSwatch);
  MaterialColor kCustomAccentColor = MaterialColor(0xFFFFD166, _goldSwatch);
}

// Teal Swatch (Primary)
Map<int, Color> _tealSwatch = {
  50: const Color(0xFFE6F7F5),
  100: const Color(0xFFC1ECE8),
  200: const Color(0xFF97E0D9),
  300: const Color(0xFF6DD4CA),
  400: const Color(0xFF4DCABE),
  500: const Color(0xFF2AB7CA),
  600: const Color(0xFF26A9B9),
  700: const Color(0xFF2096A3),
  800: const Color(0xFF1A838D),
  900: const Color(0xFF106167),
};

// Purple Swatch (Secondary)
Map<int, Color> _purpleSwatch = {
  50: const Color(0xFFF3E5F5),
  100: const Color(0xFFE1BEE7),
  200: const Color(0xFFCE93D8),
  300: const Color(0xFFBA68C8),
  400: const Color(0xFFAB47BC),
  500: const Color(0xFF9B5DE5),
  600: const Color(0xFF8E4ECB),
  700: const Color(0xFF7E3FB2),
  800: const Color(0xFF6F3099),
  900: const Color(0xFF5D217F),
};

// Gold Swatch (Accent)
Map<int, Color> _goldSwatch = {
  50: const Color(0xFFFFF8E1),
  100: const Color(0xFFFFECB3),
  200: const Color(0xFFFFE082),
  300: const Color(0xFFFFD166),
  400: const Color(0xFFFFCA28),
  500: const Color(0xFFFFC107),
  600: const Color(0xFFFFB300),
  700: const Color(0xFFFFA000),
  800: const Color(0xFFFF8F00),
  900: const Color(0xFFFF6F00),
};