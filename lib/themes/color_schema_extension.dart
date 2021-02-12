import 'package:flutter/material.dart';

extension ColorSchemaExtension on ColorScheme {
  static const Color _sidebar = Color(0xFFF0F0F0);
  static const Color _dark_sidebar = Color(0xFF202020);

  static const Color _divider_line = Color(0xFFF2F2F2);
  static const Color _divider_dark_line = Color(0xFF3B3B3B);

  static const Color _input_background = Color(0xFFF8F8F8);
  static const Color _dark_input_background = Color(0xFF1F1F1F);

  static const Color _mask = Color(0x00000000);
  static const Color _dark_mask = Color(0x4D000000);

  static const Color _text_1 = Color(0xFF262626);
  static const Color _dark_text_1 = Color(0xFFA8A8A8);

  static const Color _text_2 = Color(0xff4b5c76);
  // static const Color _text_2 = Color(0xFF595959);
  static const Color _dark_text_2 = Color(0xFFA8A8A8);

  static const Color _text_3 = Color(0xFF8C8C8C);
  static const Color _dark_text_3 = Color(0xFF8C8C8C);

  static const Color _text_4 = Color(0xFFBFBFBF);
  static const Color _dark_text_4 = Color(0xFF696969);

  static const Color _text_5 = Color(0xFFEFEFEF);
  static const Color _dark_text_5 = Color(0xFF4C4C4C);

  static const Color _text_6 = Color(0xFFFFFFFF);
  static const Color _dark_text_6 = Color(0xFFFFFFFF);

  static const Color _toast_text = Color(0xFFFFFFFF);
  static const Color _dark_toast_text = Color(0xFF1D1D1D);

  static const Color _toast_icon = Color(0xFFFFFFFF);
  static const Color _dark_toast_icon = Color(0xFF696969);

  static const Color _toast_background = Color(0xCC000000);
  static const Color _dark_toast_background = Color(0xCCFFFFFF);

  static const Color _dialog_cancel_background = Color(0xFFE6E6E6);
  static const Color _dark_dialog_cancel_background = Color(0xFF1F1F1F);

  static const Color _border_color = Color(0xFFE7E7E7);
  static const Color _dark_border_color = Color(0xFFE7E7E7);

  static const Color _material_shadow_color = Color(0x0F000000);
  static const Color _dark_material_shadow_color = Color(0x0F000000);

  static const Color _track_color = Color(0x40636363);
  static const Color _dark_track_color = Color(0x40636363);

  static const Color _sublist_background = Color(0xFFF5F5F8);
  static const Color _dark_sublist_background = Color(0xFF363636);

  static const Color _normal_button_background = Color(0xFFE4F6EC);
  static const Color _dark_normal_button_background = Color(0xFFE4F6EC);

  static const Color _imbar_icon_color = Color(0xFFB7B7B7);
  static const Color _dark_imbar_icon_color = Color(0xFFB7B7B7);

  static const Color _thrice_color = Color(0xFFFFAF64);
  static const Color _dark_thrice_color = Color(0xFFFFAF64);

  static const Color _on_thrice_color = Color(0xFFFFFFFF);
  static const Color _dark_on_thrice_color = Color(0xFFFFFFFF);

  Color get sidebar {
    if (brightness == Brightness.light) {
      return _sidebar;
    }

    return _dark_sidebar;
  }

  Color get dividerLine {
    if (brightness == Brightness.light) {
      return _divider_line;
    }

    return _divider_dark_line;
  }

  Color get inputBackground {
    if (brightness == Brightness.light) {
      return _input_background;
    }

    return _dark_input_background;
  }

  Color get mask {
    if (brightness == Brightness.light) {
      return _mask;
    }

    return _dark_mask;
  }

  Color get textTitle {
    if (brightness == Brightness.light) {
      return _text_1;
    }

    return _dark_text_1;
  }

  Color get textContent {
    if (brightness == Brightness.light) {
      return _text_2;
    }

    return _dark_text_2;
  }

  Color get textIconCaption {
    if (brightness == Brightness.light) {
      return _text_3;
    }

    return _dark_text_3;
  }

  Color get textCaption {
    if (brightness == Brightness.light) {
      return _text_4;
    }

    return _dark_text_4;
  }

  Color get textHit {
    if (brightness == Brightness.light) {
      return _text_5;
    }

    return _dark_text_5;
  }

  Color get textButton {
    if (brightness == Brightness.light) {
      return _text_6;
    }

    return _dark_text_6;
  }

  Color get toastText {
    if (brightness == Brightness.light) {
      return _toast_text;
    }

    return _dark_toast_text;
  }

  Color get toastIcon {
    if (brightness == Brightness.light) {
      return _toast_icon;
    }

    return _dark_toast_icon;
  }

  Color get toastBackground {
    if (brightness == Brightness.light) {
      return _toast_background;
    }

    return _dark_toast_background;
  }

  Color get dialogCancelBackground {
    if (brightness == Brightness.light) {
      return _dialog_cancel_background;
    }

    return _dark_dialog_cancel_background;
  }

  Color get barrierColor {
    return _dark_mask;
  }

  Color get borderColor {
    if (brightness == Brightness.light) {
      return _border_color;
    }

    return _dark_border_color;
  }

  Color get materialShadowColor {
    if (brightness == Brightness.light) {
      return _material_shadow_color;
    }

    return _dark_material_shadow_color;
  }

  Color get trackColor {
    if (brightness == Brightness.light) {
      return _track_color;
    }

    return _dark_track_color;
  }

  Color get sublistBackground {
    if (brightness == Brightness.light) {
      return _sublist_background;
    }

    return _dark_sublist_background;
  }

  Color get normalButtonBackground {
    if (brightness == Brightness.light) {
      return _normal_button_background;
    }

    return _dark_normal_button_background;
  }

  Color get imbarIconColor {
    if (brightness == Brightness.light) {
      return _imbar_icon_color;
    }

    return _dark_imbar_icon_color;
  }

  Color get thriceColor =>
      brightness == Brightness.light ? _thrice_color : _dark_thrice_color;

  Color get onThriceColor =>
      brightness == Brightness.light ? _on_thrice_color : _dark_on_thrice_color;
}
