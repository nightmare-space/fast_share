import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color fontColor = Color(0xff201b1a);
  static const Color sendByUser = Color(0xffedbac8);
  static Color grey1 = grey.shade100;
  static Color grey2 = grey.shade200;
}

extension ThemeDataExt on ThemeData {}

Color grey1 = grey.shade100;
Color grey2 = grey.shade200;
Color grey3 = grey.shade300;
Color grey4 = grey.shade400; // const Color grey = Colors();
const int _greyPrimaryValue = 0xFF9E9E9E;
const MaterialColor grey = MaterialColor(
  _greyPrimaryValue,
  <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF3F4F9),
    200: Color(0xffe8e9ee),
    300: Color(0xFFD9DAE0),
    350: Color(0xFFD6D6D6),
    400: Color(0xFFBDBDBD),
    500: Color(_greyPrimaryValue),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    850: Color(0xFF303030),
    900: Color(0xFF212121),
  },
);
