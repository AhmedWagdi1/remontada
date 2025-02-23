import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/dimansion_manager.dart';
import '../resources/font_manager.dart';
import '../resources/text_style_manager.dart';
import 'light_theme.dart';

class AppThemeManager {
  const AppThemeManager._();

  static ValueNotifier<bool> darkModeEnabled = ValueNotifier(false);
  static setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness:
            themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
      ),
    );
  }

  static ButtonStyle elevatedButtonStyleTheme({
    required Color buttonColor,
    required Color textColor,
    Color? buttonColorPressed,
    Color? textColorPressed,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
          TextStylesManager.gessMedium.copyWith(fontSize: FontSize.s16)),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(
        const Size(
          double.infinity,
          AppSize.buttonHeight,
        ),
      ),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return buttonColorPressed ?? LightThemeColors.secondary;
          }
          return buttonColor;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return textColorPressed ?? textColor;
          }
          return textColor;
        },
      ),
    );
  }
}
