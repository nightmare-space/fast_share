import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'theme.dart';

ThemeData dark() {
  final lightThemeData = ThemeData.dark(useMaterial3: true);
  ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
  return lightThemeData.copyWith(
    primaryColor: colorScheme.primary,
    scaffoldBackgroundColor: colorScheme.surface,
    primaryIconTheme: lightThemeData.primaryIconTheme.copyWith(
      color: colorScheme.onSurface,
    ),
    iconTheme: lightThemeData.iconTheme.copyWith(
      color: colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: colorScheme.surfaceContainer,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        gapPadding: 0,
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.w),
        gapPadding: 0,
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
      ),
      filled: true,
    ),
    appBarTheme: lightThemeData.appBarTheme.copyWith(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actionsIconTheme: lightThemeData.iconTheme.copyWith(color: colorScheme.primary),
      titleTextStyle: lightThemeData.textTheme.titleLarge!.copyWith(fontSize: 18.w, fontWeight: FontWeight.bold),
    ),
    dividerColor: colorScheme.outline,
    dividerTheme: DividerThemeData(color: colorScheme.outline, space: 1.w),
    popupMenuTheme: PopupMenuThemeData(color: colorScheme.surface),
    textTheme: lightThemeData.textTheme.copyWith(
      bodyMedium: lightThemeData.textTheme.bodyMedium!.copyWith(
        fontSize: 14.w,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        fontFamily: 'MiSans',
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return null;
        }
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
    ),
    colorScheme: colorScheme,
  );
}
