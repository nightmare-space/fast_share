// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:speed_share/themes/color_extension.dart';

import 'lib_color_schemes.g.dart';

// 默认的light和dark的主题
class DefaultThemeData {
  DefaultThemeData._();

  static ThemeData dark() {
    final darkThemeData = ThemeData.dark(
      useMaterial3: true,
    );
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xff6A6DED),
      brightness: Brightness.dark,
    );
    // ThemeData
    return darkThemeData.copyWith(
      colorScheme: darkColorScheme,
      primaryColor: darkColorScheme.primary,
      scaffoldBackgroundColor: darkColorScheme.background,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      primaryIconTheme: darkThemeData.iconTheme.copyWith(
        color: darkColorScheme.onSurface,
      ),
      iconTheme: darkThemeData.iconTheme.copyWith(
        color: darkColorScheme.onSurface,
      ),
      appBarTheme: darkThemeData.appBarTheme.copyWith(
        centerTitle: true,
        color: darkColorScheme.surface,
        elevation: 0,
        iconTheme: darkThemeData.iconTheme.copyWith(
          color: const Color(0xFFA8A8A8),
        ),
        actionsIconTheme: darkThemeData.iconTheme.copyWith(
          color: const Color(0xFF8C8C8C),
        ),
        toolbarTextStyle: darkThemeData.textTheme.titleLarge!.copyWith(
          fontSize: Dimens.font_sp20,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFA8A8A8),
        ),
      ),
      tabBarTheme: darkThemeData.tabBarTheme.copyWith(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: Dimens.gap_dp2,
            color: darkColorScheme.onPrimary,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: darkColorScheme.onPrimary,
        labelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
        labelPadding: EdgeInsets.only(top: Dimens.gap_dp8, bottom: Dimens.gap_dp10),
        unselectedLabelColor: darkColorScheme.onSurface,
        unselectedLabelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
      ),
      unselectedWidgetColor: const Color(0xFF696969),
      dividerColor: darkColorScheme.outline,
      dividerTheme: DividerThemeData(
        color: darkColorScheme.outline,
        space: Dimens.gap_dp1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: darkColorScheme.surface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: darkColorScheme.surface2,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          gapPadding: 0,
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          gapPadding: 0,
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        filled: true,
      ),
    );
  }

  static ThemeData light({
    Color? primary,
  }) {
    final lightThemeData = ThemeData.light().copyWith();
    ColorScheme colorScheme = lightColorScheme.copyWith();
    return lightThemeData.copyWith(
      primaryColor: colorScheme.primary,
      colorScheme: colorScheme,
      // Desktop有高斯模糊背景
      scaffoldBackgroundColor: colorScheme.background,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      primaryIconTheme: lightThemeData.primaryIconTheme.copyWith(
        color: colorScheme.onSurface,
      ),
      iconTheme: lightThemeData.iconTheme.copyWith(
        color: colorScheme.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.surface2,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          gapPadding: 0,
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.w),
          gapPadding: 0,
          borderSide: const BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        filled: true,
      ),
      appBarTheme: lightThemeData.appBarTheme.copyWith(
        systemOverlayStyle: OverlayStyle.light,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: lightThemeData.iconTheme.copyWith(
          color: const Color(0xFF595959),
        ),
        actionsIconTheme: lightThemeData.iconTheme.copyWith(
          color: colorScheme.primary,
        ),
        titleTextStyle: lightThemeData.textTheme.titleLarge!.copyWith(
          fontSize: 18.w,
          fontWeight: FontWeight.bold,
        ),
      ),
      tabBarTheme: lightThemeData.tabBarTheme.copyWith(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: Dimens.gap_dp2, color: colorScheme.primary),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
        labelPadding: EdgeInsets.only(top: Dimens.gap_dp8, bottom: Dimens.gap_dp10),
        unselectedLabelColor: colorScheme.onSurface,
        unselectedLabelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
      ),
      unselectedWidgetColor: const Color(0xFFBFBFBF),
      dividerColor: colorScheme.outline,
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        space: Dimens.gap_dp1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surface,
      ),
      textTheme: lightThemeData.textTheme.copyWith(
        bodyMedium: lightThemeData.textTheme.bodyMedium!.copyWith(fontSize: 14.w, fontWeight: FontWeight.w500, color: colorScheme.onBackground, fontFamily: 'MiSans'),
      ),
    );
  }
}
