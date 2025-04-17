import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

class MindfulMateThemeData {
  static final lightMode = ThemeData(
    scaffoldBackgroundColor: injector.palette.lightGray,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: injector.palette.textColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        color: injector.palette.textColor,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.inter(
        color: injector.palette.textColor,
        fontSize: 14,
      ),
      titleLarge: GoogleFonts.poppins(
        color: injector.palette.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.inter(
        color: injector.palette.pureWhite,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    primaryColor: injector.palette.primaryColor,
    dividerColor: injector.palette.dividerColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: injector.palette.primaryColor,
      brightness: Brightness.light,
      secondary: injector.palette.secondaryColor,
      tertiary: injector.palette.accentColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: injector.palette.pureWhite,
      iconTheme: IconThemeData(color: injector.palette.primaryColor),
      titleTextStyle: GoogleFonts.poppins(
        color: injector.palette.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: injector.palette.primaryColor,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    useMaterial3: true,
  );

  static final darkMode = ThemeData(
    scaffoldBackgroundColor: injector.palette.darkModeBackground,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        color: injector.palette.pureWhite,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.inter(
        color: injector.palette.pureWhite,
        fontSize: 16,
      ),
      titleLarge: GoogleFonts.poppins(
        color: injector.palette.pureWhite,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.inter(
        color: injector.palette.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: injector.palette.darkModeBackground,
      iconTheme: IconThemeData(color: injector.palette.primaryColor),
      titleTextStyle: GoogleFonts.poppins(
        color: injector.palette.pureWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    primaryColor: injector.palette.primaryColor,
    dividerColor: injector.palette.dividerColor.withOpacity(0.2),
    colorScheme: ColorScheme.fromSeed(
      seedColor: injector.palette.primaryColor,
      brightness: Brightness.dark,
      secondary: injector.palette.secondaryColor,
      tertiary: injector.palette.accentColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: injector.palette.primaryColor,
        textStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    useMaterial3: true,
  );
}
