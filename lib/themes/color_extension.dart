import 'package:flutter/material.dart';
// 一些扩展
extension ColorExt on State {
  ColorScheme get scheme => Theme.of(context).colorScheme;
}

extension ColorSchemeExt on ColorScheme {
  Color get surface1 => primary.withOpacity(0.05);
  Color get surface2 => primary.withOpacity(0.08);
  Color get surface3 => primary.withOpacity(0.11);
  Color get surface4 => primary.withOpacity(0.12);
}
