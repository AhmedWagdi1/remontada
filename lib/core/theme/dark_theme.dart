import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/utils.dart';
import '../resources/text_style_manager.dart';

// Define your dark theme colors
class DarkThemeColors {
  const DarkThemeColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1E2025);

  // Secondary Colors
  static const Color secondary = Color(0xFFA7A7A7);

  // Background Color
  static const Color background = Color(0xFF161616);
  static const Color buttonBackground = primary;
  static const Color dialogBackground = primary;
  static const Color textFieldBackground = primary;
  static const Color appBarBackground = background;
  static const Color scaffoldBackground = background;
  static const Color bottomSheetBackground = background;
  static const Color bottomNavigationBarBackground = primary;
  static Color barrierBackground = background.withOpacity(0.53);

  // Surface Colors
  static const Color surface = Color(0xFF1E251F);
  static Color surfaceSecondary = const Color(0xFF3C3C3C).withOpacity(0.61);
  static Color surfaceSuccess = const Color(0xFF32E444).withOpacity(0.35);
  static Color surfaceError = DarkThemeColors.error.withOpacity(0.35);

  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0x90FFFFFF);
  static const Color textColorPrimary = Color(0xFF9377B9);
  static const Color textHint = Color(0xFFA7A7A7);

  // button Colors
  static const Color buttonColor = Color(0xFF9377B9);

  // static const Color textHint = Color(0xFFA7A7A7);

  // Validation Colors:
  static const Color error = Color(0xFFFF697D);
  static const Color success = Color(0xFF32E444);
  static const Color warning = Color(0xFFE39600);

  // Icons Colors

  // border Colors
  static const Color border = Color(0xFFA7A7A7);
  static const Color borderVariant = Color(0x26A7A7A7);

  // shadow
  static const Color shadow = Color(0x07FFFFFF);
  static const Color shadowVariant = Color(0x0AFFFFFF);

  // gradient
  static List<Color> gradient = [
    Colors.white,
    // Colors.white.withOpacity(0.5),
    Colors.white.withOpacity(0),
  ];
}

class DarkTheme {
  static ThemeData getTheme() {
    // AppThemeManager.setStatusBarAndNavigationBarColors(ThemeMode.dark);

    return ThemeData(
      //* Dark Theme
      useMaterial3: true,
      brightness: Brightness.dark,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: "DINNext",
      // Utils.lang == "en" ? "arista" : "DINNext",
      //* Card Theme *//
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.background,
        // color: DarkThemeColors.background,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: DarkThemeColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: Utils.lang == "en"
            ? TextStylesManager.aristaBold.copyWith(
                color: DarkThemeColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500)
            : TextStylesManager.gessBold.copyWith(
                color: DarkThemeColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500),
        iconTheme: const IconThemeData(color: DarkThemeColors.textPrimary),
        actionsIconTheme:
            const IconThemeData(color: DarkThemeColors.textPrimary),
      ),
      //* Color Scheme
      //#9377B9
      //#FFFFFF opacity 0.60
      //#FFFFFF opacity 0.05
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF9377B9),
        onPrimary: Color(0xff161616),
        primaryContainer: Color(0xFF1E1E1E),
        onPrimaryContainer: Color(0xFF410002),
        secondary: Color(0xFF9377B9),
        onSecondary: Color(0xFFD0C4E1),
        secondaryContainer: Color(0xFFCFE5FF),
        onSecondaryContainer: Color(0xFF001D34),
        tertiary: Colors.white,
        onTertiary: Color(0xFF9377B9),
        tertiaryContainer: Color(0xFFFFDAD6),
        onTertiaryContainer: Color(0xFF410002),
        error: Colors.red,
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xff121212),
        onBackground: Color(0xFF001F25),
        surface: Color(0x05FFFFFF),
        // surface: Color(0xFFF8FDFF),
        onSurface: Color(0xFF001F25),
        surfaceVariant: Color(0xFFF5DDDA),
        onSurfaceVariant: Color(0xFF534341),
        outline: Color(0xFF857371),
        onInverseSurface: Color(0xFFD6F6FF),
        inverseSurface: Color(0xFF00363F),
        inversePrimary: Color(0xFFFFB4AB),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF9C423A),
        outlineVariant: Color(0xFFD8C2BF),
        scrim: Color(0xFF000000),
      ),

      //* App Bar Theme
      scaffoldBackgroundColor: DarkThemeColors.background,
      //* Text Theme
      textTheme: TextTheme(
        // Display
        displayLarge: Utils.lang == "en"
            ? TextStylesManager.aristaBold
                .copyWith(color: DarkThemeColors.primary)
            : TextStylesManager.gessBold
                .copyWith(color: DarkThemeColors.primary),

        // Header
        headlineLarge: Utils.lang == "en"
            ? TextStylesManager.aristaBold
                .copyWith(color: DarkThemeColors.textPrimary)
            : TextStylesManager.gessBold
                .copyWith(color: DarkThemeColors.textPrimary),

        // Title
        titleLarge: Utils.lang == "en"
            ? TextStylesManager.aristaBold.copyWith(
                color: DarkThemeColors.textPrimary,
              )
            : TextStylesManager.gessBold
                .copyWith(color: DarkThemeColors.textPrimary),
        titleMedium: Utils.lang == "en"
            ? TextStylesManager.aristaMedium.copyWith(
                color: DarkThemeColors.textPrimary, fontWeight: FontWeight.w500)
            : TextStylesManager.aristaMedium.copyWith(
                color: DarkThemeColors.textPrimary,
                fontWeight: FontWeight.w500),
        titleSmall: Utils.lang == "en"
            ? TextStylesManager.aristaRegular
                .copyWith(color: DarkThemeColors.textHint)
            : TextStylesManager.gessRegular
                .copyWith(color: DarkThemeColors.textHint),

        // Body Text
        bodyLarge: Utils.lang == "en"
            ? TextStylesManager.aristaBold
                .copyWith(color: DarkThemeColors.textPrimary)
            : TextStylesManager.gessBold
                .copyWith(color: DarkThemeColors.textPrimary),
        bodyMedium: Utils.lang == "en"
            ? TextStylesManager.aristaMedium
                .copyWith(color: DarkThemeColors.textPrimary)
            : TextStylesManager.aristaMedium
                .copyWith(color: DarkThemeColors.textPrimary),
        bodySmall: Utils.lang == "en"
            ? TextStylesManager.aristaRegular
                .copyWith(color: DarkThemeColors.textSecondary)
            : TextStylesManager.gessRegular
                .copyWith(color: DarkThemeColors.textSecondary),

        // label
        labelLarge: Utils.lang == "en"
            ? TextStylesManager.aristaMedium
                .copyWith(color: DarkThemeColors.success)
            : TextStylesManager.gessMedium
                .copyWith(color: DarkThemeColors.success),
        labelMedium: Utils.lang == "en"
            ? TextStylesManager.aristaMedium
                .copyWith(color: DarkThemeColors.error)
            : TextStylesManager.gessMedium
                .copyWith(color: DarkThemeColors.error),
      ),

      //*  bottomNavigationBarTheme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(),

      //* Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(),

      //* Tab Bar Theme
      tabBarTheme: TabBarTheme(),

      //* ElevatedButtonThemeData
      elevatedButtonTheme: ElevatedButtonThemeData(),

      //* TextButtonThemeData
      textButtonTheme: TextButtonThemeData(),

      //* dividerTheme
      dividerTheme: const DividerThemeData(),

      //* Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(),
    );
  }
}
