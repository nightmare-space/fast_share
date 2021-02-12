import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore_for_file: non_constant_identifier_names
class Dimens {
  Dimens._();
  static double get font_sp1 => ScreenUtil().setSp(1.0).toDouble();
  static double get font_sp10 => ScreenUtil().setSp(10.0).toDouble();
  static double get font_sp11 => ScreenUtil().setSp(11.0).toDouble();
  static double get font_sp12 => ScreenUtil().setSp(12.0).toDouble();
  static double get font_sp13 => ScreenUtil().setSp(13.0).toDouble();
  static double get font_sp14 => ScreenUtil().setSp(14.0).toDouble();
  static double get font_sp16 => ScreenUtil().setSp(16.0).toDouble();
  static double get font_sp18 => ScreenUtil().setSp(18.0).toDouble();
  static double get font_sp20 => ScreenUtil().setSp(20.0).toDouble();
  static double get font_sp24 => ScreenUtil().setSp(24.0).toDouble();

  static double get gap_dp1 => ScreenUtil().setWidth(1.0).toDouble();
  static double get gap_dp2 => ScreenUtil().setWidth(2.0).toDouble();
  static double get gap_dp4 => ScreenUtil().setWidth(4.0).toDouble();
  static double get gap_dp6 => ScreenUtil().setWidth(6.0).toDouble();
  static double get gap_dp8 => ScreenUtil().setWidth(8.0).toDouble();
  static double get gap_dp10 => ScreenUtil().setWidth(10.0).toDouble();
  static double get gap_dp12 => ScreenUtil().setWidth(12.0).toDouble();
  static double get gap_dp14 => ScreenUtil().setWidth(14.0).toDouble();
  static double get gap_dp16 => ScreenUtil().setWidth(16.0).toDouble();
  static double get gap_dp18 => ScreenUtil().setWidth(18.0).toDouble();
  static double get gap_dp20 => ScreenUtil().setWidth(20.0).toDouble();
  static double get gap_dp22 => ScreenUtil().setWidth(22.0).toDouble();
  static double get gap_dp24 => ScreenUtil().setWidth(24.0).toDouble();
  static double get gap_dp26 => ScreenUtil().setWidth(26.0).toDouble();
  static double get gap_dp28 => ScreenUtil().setWidth(28.0).toDouble();
  static double get gap_dp30 => ScreenUtil().setWidth(30.0).toDouble();
  static double get gap_dp32 => ScreenUtil().setWidth(32.0).toDouble();
  static double get gap_dp36 => ScreenUtil().setWidth(36.0).toDouble();
  static double get gap_dp40 => ScreenUtil().setWidth(40.0).toDouble();
  static double get gap_dp44 => ScreenUtil().setWidth(44.0).toDouble();
  static double get gap_dp46 => ScreenUtil().setWidth(46.0).toDouble();
  static double get gap_dp48 => ScreenUtil().setWidth(48.0).toDouble();
  static double get gap_dp50 => ScreenUtil().setWidth(50.0).toDouble();
  static double get gap_dp52 => ScreenUtil().setWidth(52.0).toDouble();
  static double get gap_dp54 => ScreenUtil().setWidth(54.0).toDouble();
  static double get gap_dp56 => ScreenUtil().setWidth(56.0).toDouble();
  static double get gap_dp60 => ScreenUtil().setWidth(60.0).toDouble();
  static double get gap_dp80 => ScreenUtil().setWidth(80.0).toDouble();
  static double get gap_dp92 => ScreenUtil().setWidth(92.0).toDouble();
  static double get screenWidth => ScreenUtil.screenWidth;
  static double setWidth(num width) => ScreenUtil().setWidth(width).toDouble();
  static double setSp(num sp) =>
      ScreenUtil().setSp(sp, allowFontScalingSelf: true).toDouble();
}
