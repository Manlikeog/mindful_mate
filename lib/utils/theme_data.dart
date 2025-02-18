import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindful_mate/utils/app_settings/injector.dart';

// class MindfulMateThemeData {
//   static final lightMode = ThemeData(
//     scaffoldBackgroundColor: injector.palette.pureWhite,
//     textTheme: GoogleFonts.urbanistTextTheme().copyWith(
//       displayLarge: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       bodyLarge: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       bodyMedium: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       bodySmall: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       displayMedium: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       displaySmall: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       headlineLarge: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       headlineMedium: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       headlineSmall: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       labelLarge: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       labelMedium: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       labelSmall: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       titleLarge: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       titleMedium: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//       titleSmall: GoogleFonts.urbanist(
//         color: injector.palette.textColor,
//       ),
//     ),
//     fontFamily: GoogleFonts.urbanist().fontFamily,
//     primaryColor: injector.palette.primaryColor,
//     dividerColor: injector.palette.dividerColor,
//     colorScheme: ColorScheme.fromSwatch(
//       primarySwatch: injector.palette.kCustomPryColor,
//       brightness: Brightness.light,
//       accentColor: injector.palette.primaryColor,
//     ),
//     highlightColor: injector.palette.transparent,
//     hoverColor: injector.palette.transparent,
//     focusColor: injector.palette.transparent,
//     splashColor: injector.palette.transparent,
//     appBarTheme: AppBarTheme(
//       backgroundColor: injector.palette.pureWhite,
//     ),
//     disabledColor: Colors.grey,
//     useMaterial3: true,
//   );

//   static final darkMode = ThemeData(
//     scaffoldBackgroundColor: injector.palette.darkModeBackground,
//     textTheme: GoogleFonts.urbanistTextTheme().copyWith(
//       displayLarge: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       bodyLarge: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       bodyMedium: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       bodySmall: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       displayMedium: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       displaySmall: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       headlineLarge: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       headlineMedium: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       headlineSmall: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       labelLarge: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       labelMedium: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       labelSmall: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       titleLarge: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       titleMedium: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//       titleSmall: GoogleFonts.urbanist(
//         color: injector.palette.pureWhite,
//       ),
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: injector.palette.darkModeBackground,
//     ),

//     fontFamily: GoogleFonts.urbanist().fontFamily,
//     primaryColor: injector.palette.primaryColor,
//     dividerColor: injector.palette.dividerColor,
//     colorScheme: ColorScheme.fromSwatch(
//       primarySwatch: injector.palette.kCustomPryColor,
//       brightness: Brightness.dark,
//       accentColor: injector.palette.primaryColor,
//     ),
//     highlightColor: injector.palette.transparent,
//     hoverColor: injector.palette.transparent,
//     focusColor: injector.palette.transparent,
//     splashColor: injector.palette.transparent,

//     disabledColor: Colors.grey,
//     useMaterial3: true,
//     //  accentColor: Colors.orange,
//   );

// }

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
