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

  static TextStyle get _subtitle1 =>
      _ibmPlexSansTextTheme.titleMedium!.copyWith(
        fontSize: Sizes.dimen_16.sp,
        color: AppColor.grey6,
      );

  static TextStyle get _bodyText1 => _ibmPlexSansTextTheme.bodyLarge!.copyWith(
        fontSize: Sizes.dimen_14.sp,
        color: AppColor.black,
      );

  static TextStyle get _bodyText2 => _ibmPlexSansTextTheme.bodyMedium!.copyWith(
        fontSize: Sizes.dimen_12.sp,
        color: AppColor.grey4,
      );

  static TextTheme getTextTheme() => TextTheme(
        titleLarge: _whiteHeadline6,
        titleMedium: _subtitle1,
        bodyLarge: _bodyText1,
        bodyMedium: _bodyText2,
      );
}
