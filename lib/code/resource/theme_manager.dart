import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';

ThemeData getTheme() {
  return ThemeData(

      scaffoldBackgroundColor: Color(0xffF2F3F7),
      primaryColor: Color(0xff30CA00),
      buttonColor: Color(0xff30CA00),
      appBarTheme: AppBarTheme(
        backgroundColor:  Color(0xff30CA00)
      ),
      // text
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xff30CA00),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.w800, fontSize: 32.sp, height: 0.48),
      ));
}
