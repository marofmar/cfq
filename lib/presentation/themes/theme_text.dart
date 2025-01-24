import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cfq/common/constants/size_constants.dart';
import 'package:cfq/common/extensions/size_extensions.dart';

class ThemeText {
  const ThemeText._();

  static TextTheme get _ibmPlexSansTextTheme =>
      GoogleFonts.ibmPlexSansTextTheme();
  static TextStyle get _whiteHeadline6 =>
      _ibmPlexSansTextTheme.titleLarge!.copyWith(
        fontSize: Sizes.dimen_20.sp,
        color: AppColor.black,
      );
  static TextTheme getTextTheme() => TextTheme(
        titleLarge: _whiteHeadline6,
      );
}
