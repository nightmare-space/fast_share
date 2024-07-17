import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff575992),
      surfaceTint: Color(0xff575992),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe1e0ff),
      onPrimaryContainer: Color(0xff13144a),
      secondary: Color(0xff5d5c72),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe2e0f9),
      onSecondaryContainer: Color(0xff191a2c),
      tertiary: Color(0xff795369),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd8ec),
      onTertiaryContainer: Color(0xff2e1125),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff1b1b21),
      onSurfaceVariant: Color(0xff47464f),
      outline: Color(0xff777680),
      outlineVariant: Color(0xffc8c5d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303036),
      inversePrimary: Color(0xffc0c1ff),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff13144a),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff404178),
      secondaryFixed: Color(0xffe2e0f9),
      onSecondaryFixed: Color(0xff191a2c),
      secondaryFixedDim: Color(0xffc6c4dd),
      onSecondaryFixedVariant: Color(0xff454559),
      tertiaryFixed: Color(0xffffd8ec),
      onTertiaryFixed: Color(0xff2e1125),
      tertiaryFixedDim: Color(0xffe9b9d3),
      onTertiaryFixedVariant: Color(0xff5f3c51),
      surfaceDim: Color(0xffdcd9e0),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fa),
      surfaceContainer: Color(0xfff0ecf4),
      surfaceContainerHigh: Color(0xffeae7ef),
      surfaceContainerHighest: Color(0xffe4e1e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c3d74),
      surfaceTint: Color(0xff575992),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6e6faa),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff414155),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff737388),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5b384d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff916980),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff1b1b21),
      onSurfaceVariant: Color(0xff43424b),
      outline: Color(0xff5f5e67),
      outlineVariant: Color(0xff7b7983),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303036),
      inversePrimary: Color(0xffc0c1ff),
      primaryFixed: Color(0xff6e6faa),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff55578f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff737388),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5a5a6f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff916980),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff765067),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdcd9e0),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fa),
      surfaceContainer: Color(0xfff0ecf4),
      surfaceContainerHigh: Color(0xffeae7ef),
      surfaceContainerHighest: Color(0xffe4e1e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1a1b51),
      surfaceTint: Color(0xff575992),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3c3d74),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff202133),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff414155),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff36182c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5b384d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff23232b),
      outline: Color(0xff43424b),
      outlineVariant: Color(0xff43424b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303036),
      inversePrimary: Color(0xffeceaff),
      primaryFixed: Color(0xff3c3d74),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff25265c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff414155),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b2b3e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5b384d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff422236),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffdcd9e0),
      surfaceBright: Color(0xfffcf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff6f2fa),
      surfaceContainer: Color(0xfff0ecf4),
      surfaceContainerHigh: Color(0xffeae7ef),
      surfaceContainerHighest: Color(0xffe4e1e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc0c1ff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff292a60),
      primaryContainer: Color(0xff404178),
      onPrimaryContainer: Color(0xffe1e0ff),
      secondary: Color(0xffc6c4dd),
      onSecondary: Color(0xff2e2f42),
      secondaryContainer: Color(0xff454559),
      onSecondaryContainer: Color(0xffe2e0f9),
      tertiary: Color(0xffe9b9d3),
      onTertiary: Color(0xff46263a),
      tertiaryContainer: Color(0xff5f3c51),
      onTertiaryContainer: Color(0xffffd8ec),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131318),
      onSurface: Color(0xffe4e1e9),
      onSurfaceVariant: Color(0xffc8c5d0),
      outline: Color(0xff918f9a),
      outlineVariant: Color(0xff47464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e9),
      inversePrimary: Color(0xff575992),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff13144a),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff404178),
      secondaryFixed: Color(0xffe2e0f9),
      onSecondaryFixed: Color(0xff191a2c),
      secondaryFixedDim: Color(0xffc6c4dd),
      onSecondaryFixedVariant: Color(0xff454559),
      tertiaryFixed: Color(0xffffd8ec),
      onTertiaryFixed: Color(0xff2e1125),
      tertiaryFixedDim: Color(0xffe9b9d3),
      onTertiaryFixedVariant: Color(0xff5f3c51),
      surfaceDim: Color(0xff131318),
      surfaceBright: Color(0xff39383f),
      surfaceContainerLowest: Color(0xff0e0e13),
      surfaceContainerLow: Color(0xff1b1b21),
      surfaceContainer: Color(0xff1f1f25),
      surfaceContainerHigh: Color(0xff2a292f),
      surfaceContainerHighest: Color(0xff35343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc5c6ff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff0d0d45),
      primaryContainer: Color(0xff8a8bc8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcac8e1),
      onSecondary: Color(0xff141526),
      secondaryContainer: Color(0xff8f8fa5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffedbdd8),
      onTertiary: Color(0xff280c1f),
      tertiaryContainer: Color(0xffaf849d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131318),
      onSurface: Color(0xfffdf9ff),
      onSurfaceVariant: Color(0xffccc9d4),
      outline: Color(0xffa4a1ac),
      outlineVariant: Color(0xff83828c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e9),
      inversePrimary: Color(0xff41427a),
      primaryFixed: Color(0xffe1e0ff),
      onPrimaryFixed: Color(0xff070641),
      primaryFixedDim: Color(0xffc0c1ff),
      onPrimaryFixedVariant: Color(0xff2f3066),
      secondaryFixed: Color(0xffe2e0f9),
      onSecondaryFixed: Color(0xff0f0f21),
      secondaryFixedDim: Color(0xffc6c4dd),
      onSecondaryFixedVariant: Color(0xff343448),
      tertiaryFixed: Color(0xffffd8ec),
      onTertiaryFixed: Color(0xff22071a),
      tertiaryFixedDim: Color(0xffe9b9d3),
      onTertiaryFixedVariant: Color(0xff4d2b40),
      surfaceDim: Color(0xff131318),
      surfaceBright: Color(0xff39383f),
      surfaceContainerLowest: Color(0xff0e0e13),
      surfaceContainerLow: Color(0xff1b1b21),
      surfaceContainer: Color(0xff1f1f25),
      surfaceContainerHigh: Color(0xff2a292f),
      surfaceContainerHighest: Color(0xff35343a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffdf9ff),
      surfaceTint: Color(0xffc0c1ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc5c6ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffdf9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffcac8e1),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9f9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffedbdd8),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131318),
      onSurface: Color.fromARGB(255, 26, 16, 16),
      onSurfaceVariant: Color(0xfffdf9ff),
      outline: Color(0xffccc9d4),
      outlineVariant: Color(0xffccc9d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe4e1e9),
      inversePrimary: Color(0xff222459),
      primaryFixed: Color(0xffe6e4ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc5c6ff),
      onPrimaryFixedVariant: Color(0xff0d0d45),
      secondaryFixed: Color(0xffe6e4fe),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcac8e1),
      onSecondaryFixedVariant: Color(0xff141526),
      tertiaryFixed: Color(0xffffdeee),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffedbdd8),
      onTertiaryFixedVariant: Color(0xff280c1f),
      surfaceDim: Color(0xff131318),
      surfaceBright: Color(0xff39383f),
      surfaceContainerLowest: Color(0xff0e0e13),
      surfaceContainerLow: Color(0xff1b1b21),
      surfaceContainer: Color(0xff1f1f25),
      surfaceContainerHigh: Color(0xff2a292f),
      surfaceContainerHighest: Color(0xff35343a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
