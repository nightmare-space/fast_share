import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

import 'app_colors.dart';

class DefaultThemeData {
  static const Color _primary = AppColors.accentColor;
  static const Color _dark_primary = Color(0xFF01AAFF);

  static const Color _on_primary = Colors.white;
  static const Color _on_dark_primary = Colors.white;

  static const Color _primary_variant = Color(0xFF0C89DB);
  static const Color _dark_primary_variant = Color(0xFF0C89DB);
  // 浮动按钮类颜色
  static const Color _secondary = _primary;
  static const Color _dark_secondary = Color(0xFF61CE92);

  static const Color _on_secondary = Colors.white;
  static const Color _on_dark_secondary = Colors.white;

  static const Color _secondary_variant = Color(0xFF00954D);
  static const Color _dark_secondary_variant = Color(0xFF00954D);

  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _dark_surface = Color(0xFF282828);

  static const Color _on_surface = Color(0xFF8C8C8C);
  static const Color _on_dark_surface = Color(0xFF696969);

  static const Color _background = AppColors.background;
  static const Color _dark_background = Color(0xFF1B1B1B);

  static const Color _on_background = Color(0xFF8C8C8C);
  static const Color _on_dark_background = Color(0xFF8C8C8C);

  static const Color _error = Color(0xFFF25E5E);
  static const Color _dark_error = Color(0xFFF25E5E);

  static const Color _on_error = Color(0xFFFFFFFF);
  static const Color _on_dark_error = Color(0xFF282828);

  static const Color _divider_line = Color(0xFFF0F0F0);
  static const Color _divider_dark_line = Color(0xFF3B3B3B);

  static ThemeData dark() {
    final darkThemeData = ThemeData.dark();
    final colorSchema = darkThemeData.colorScheme.copyWith(
      primary: _dark_primary,
      primaryVariant: _dark_primary_variant,
      secondary: _dark_secondary,
      secondaryVariant: _dark_secondary_variant,
      surface: _dark_surface,
      background: _dark_background,
      error: _dark_error,
      onPrimary: _on_dark_primary,
      onSecondary: _on_dark_secondary,
      onSurface: _on_dark_surface,
      onBackground: _on_dark_background,
      onError: _on_dark_error,
    );
    return darkThemeData.copyWith(
      colorScheme: colorSchema,
      accentColor: colorSchema.onPrimary,
      scaffoldBackgroundColor: colorSchema.background,
      primaryColorBrightness: Brightness.dark,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      primaryIconTheme: darkThemeData.iconTheme.copyWith(
        color: colorSchema.onSurface,
      ),
      iconTheme: darkThemeData.iconTheme.copyWith(
        color: colorSchema.onSurface,
      ),
      appBarTheme: darkThemeData.appBarTheme.copyWith(
        centerTitle: true,
        brightness: Brightness.dark,
        color: colorSchema.surface,
        elevation: 0,
        iconTheme: darkThemeData.iconTheme.copyWith(
          color: const Color(0xFFA8A8A8),
        ),
        actionsIconTheme: darkThemeData.iconTheme.copyWith(
          color: const Color(0xFF8C8C8C),
        ),
        textTheme: TextTheme(
          headline6: darkThemeData.textTheme.headline6.copyWith(
            fontSize: Dimens.font_sp20,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFA8A8A8),
          ),
          button: darkThemeData.textTheme.button.copyWith(
            fontSize: 16,
            color: colorSchema.primary,
            fontWeight: FontWeight.w400,
          ),
          caption: darkThemeData.textTheme.caption.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8C8C8C),
          ),
        ),
      ),
      tabBarTheme: darkThemeData.tabBarTheme.copyWith(
        indicator: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: Dimens.gap_dp2, color: colorSchema.onPrimary),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colorSchema.onPrimary,
        labelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
        labelPadding:
            EdgeInsets.only(top: Dimens.gap_dp8, bottom: Dimens.gap_dp10),
        unselectedLabelColor: colorSchema.onSurface,
        unselectedLabelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
      ),
      accentTextTheme: darkThemeData.textTheme.copyWith(
        headline6: darkThemeData.textTheme.headline6.copyWith(
          color: colorSchema.onPrimary,
        ),
      ),
      unselectedWidgetColor: const Color(0xFF696969),
      toggleableActiveColor: _primary,
      dividerColor: _divider_dark_line,
      dividerTheme: DividerThemeData(
        color: _divider_dark_line,
        space: Dimens.gap_dp1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorSchema.surface,
      ),
      textTheme: darkThemeData.textTheme.copyWith(
        headline5: darkThemeData.textTheme.headline5.copyWith(
          fontSize: Dimens.font_sp24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE7E7E7),
        ),
        headline6: darkThemeData.textTheme.headline6.copyWith(
          fontSize: Dimens.font_sp20,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE7E7E7),
        ),
        subtitle1: darkThemeData.textTheme.subtitle1.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE7E7E7),
        ),
        subtitle2: darkThemeData.textTheme.subtitle2.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFE7E7E7),
        ),
        bodyText1: darkThemeData.textTheme.bodyText1.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFE7E7E7),
        ),
        bodyText2: darkThemeData.textTheme.bodyText1.copyWith(
          fontSize: Dimens.font_sp14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFE7E7E7),
        ),
        button: darkThemeData.textTheme.button.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFFFFFFF),
        ),
        caption: darkThemeData.textTheme.caption.copyWith(
          fontSize: Dimens.font_sp12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF8C8C8C),
        ),
      ),
    );
  }

  static ThemeData light() {
    final lightThemeData = ThemeData.light();
    final colorSchema = lightThemeData.colorScheme.copyWith(
      primary: _primary,
      primaryVariant: _primary_variant,
      secondary: _secondary,
      secondaryVariant: _secondary_variant,
      surface: _surface,
      background: _background,
      error: _error,
      onPrimary: _on_primary,
      onSecondary: _on_secondary,
      onSurface: _on_surface,
      onBackground: _on_background,
      onError: _on_error,
    );
    return lightThemeData.copyWith(
      colorScheme: colorSchema,
      accentColor: colorSchema.primary,
      scaffoldBackgroundColor: colorSchema.background,
      primaryColorBrightness: Brightness.light,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
      ),
      primaryIconTheme: lightThemeData.primaryIconTheme.copyWith(
        color: colorSchema.onSurface,
      ),
      iconTheme: lightThemeData.iconTheme.copyWith(
        color: colorSchema.onSurface,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: _background,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.w),
          gapPadding: 0,
          borderSide: BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.w),
          gapPadding: 0,
          borderSide: BorderSide(
            width: 0,
            color: Colors.transparent,
          ),
        ),
        filled: true,
      ),
      appBarTheme: lightThemeData.appBarTheme.copyWith(
        centerTitle: true,
        brightness: Brightness.light,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: lightThemeData.iconTheme.copyWith(
          color: const Color(0xFF595959),
        ),
        actionsIconTheme: lightThemeData.iconTheme.copyWith(
          color: colorSchema.primary,
        ),
        textTheme: TextTheme(
          headline6: lightThemeData.textTheme.headline6.copyWith(
            fontSize: Dimens.font_sp20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          button: lightThemeData.textTheme.button.copyWith(
            fontSize: 16.w,
            fontWeight: FontWeight.w400,
            color: colorSchema.primary,
          ),
          caption: lightThemeData.textTheme.caption.copyWith(
            fontSize: 14.w,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF8C8C8C),
          ),
        ),
      ),
      tabBarTheme: lightThemeData.tabBarTheme.copyWith(
        indicator: UnderlineTabIndicator(
          borderSide:
              BorderSide(width: Dimens.gap_dp2, color: colorSchema.primary),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colorSchema.primary,
        labelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
        labelPadding:
            EdgeInsets.only(top: Dimens.gap_dp8, bottom: Dimens.gap_dp10),
        unselectedLabelColor: colorSchema.onSurface,
        unselectedLabelStyle: TextStyle(
          fontSize: Dimens.font_sp16,
        ),
      ),
      accentTextTheme: lightThemeData.textTheme.copyWith(
        headline6: lightThemeData.textTheme.headline6.copyWith(
          fontSize: Dimens.font_sp18,
          fontWeight: FontWeight.w500,
          color: colorSchema.onPrimary,
        ),
      ),
      unselectedWidgetColor: const Color(0xFFBFBFBF),
      toggleableActiveColor: _primary,
      dividerColor: _divider_line,
      dividerTheme: DividerThemeData(
        color: _divider_line,
        space: Dimens.gap_dp1,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorSchema.surface,
      ),
      textTheme: lightThemeData.textTheme.copyWith(
        headline5: lightThemeData.textTheme.headline5.copyWith(
          fontSize: Dimens.font_sp24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF262626),
        ),
        headline6: lightThemeData.textTheme.headline6.copyWith(
          fontSize: Dimens.font_sp20,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF595959),
        ),
        subtitle1: lightThemeData.textTheme.subtitle1.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF262626),
        ),
        subtitle2: lightThemeData.textTheme.subtitle2.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF262626),
        ),
        bodyText1: lightThemeData.textTheme.bodyText1.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF262626),
        ),
        bodyText2: lightThemeData.textTheme.bodyText2.copyWith(
          fontSize: Dimens.font_sp14,
          fontWeight: FontWeight.w400,
          color: AppColors.fontColor,
        ),
        button: lightThemeData.textTheme.button.copyWith(
          fontSize: Dimens.font_sp16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF8C8C8C),
        ),
        caption: lightThemeData.textTheme.caption.copyWith(
          fontSize: Dimens.font_sp12,
          fontWeight: FontWeight.w400,
          color: Colors.red,
        ),
      ),
    );
  }
}
