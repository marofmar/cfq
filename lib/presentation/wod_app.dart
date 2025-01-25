import 'package:cfq/common/screenutil/screenutil.dart';
import 'package:cfq/presentation/screens/wod_page.dart';
import 'package:cfq/presentation/themes/theme_color.dart';
import 'package:cfq/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

class WodApp extends StatelessWidget {
  @override
  Widget build(Object context) {
    ScreenUtil.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CFQ',
      theme: ThemeData(
        primaryColor: AppColor.white,
        scaffoldBackgroundColor: AppColor.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.white,
          elevation: 0,
        ),
      ),
      home: const WodPage(),
    );
  }
}
