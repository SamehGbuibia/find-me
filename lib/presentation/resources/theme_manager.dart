import 'package:flutter/material.dart';
import 'package:independet/presentation/resources/colors_manager.dart';
import 'package:independet/presentation/resources/style_manager.dart';
import 'package:independet/presentation/resources/values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      // main colors
      primaryColor: ColorsManager.primary,
      primaryColorLight: ColorsManager.lightPrimary,
      splashColor: ColorsManager.lightPrimary,
      //appBar
      appBarTheme: const AppBarTheme(
        color: ColorsManager.primary,
        elevation: AppSize.s4,
        shadowColor: ColorsManager.lightPrimary,
      ),
      //buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        primary: ColorsManager.primary,
      )),
      //text styles
      textTheme: TextTheme(
        displayLarge: getRegularStyle(
            color: ColorsManager.lightPrimary, fontSize: FontSize.s26),
        headlineLarge: getRegularStyle(
            color: ColorsManager.lightPrimary, fontSize: FontSize.s16),
        headlineMedium: getRegularStyle(fontSize: FontSize.s16),
        // titleMedium: getMediumStyle(
        //     color: ColorsManager.primary, fontSize: FontSize.s16),
        // titleSmall: getRegularStyle(
        //     color: ColorsManager.white, fontSize: FontSize.s16),
        bodyLarge: getRegularStyle(fontSize: FontSize.s14),
        // bodySmall: getRegularStyle(color: ColorsManager.grey),
        // bodyMedium: getRegularStyle(
        //     color: ColorsManager.grey2, fontSize: FontSize.s12),
        // labelSmall: getBoldStyle(
        //     color: ColorsManager.primary, fontSize: FontSize.s12)
      ),
      // input decoration theme (text form field)
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.primary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.primary),
        ),
      ) // label style
      );
}
