import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //AppTheme();

  static const MaterialColor primarySwatch =
      MaterialColor(_colorPrimaryValue, <int, Color>{
    50: Color(0xFFE8EAF6),
    100: Color(0xFFC5CBE9),
    200: Color(0xFF9FA8DA),
    300: Color(0xFF7985CB),
    400: Color(0xFF5C6BC0),
    500: Color(_colorPrimaryValue),
    600: Color(0xFF394AAE),
    700: Color(0xFF3140A5),
    800: Color(0xFF29379D),
    900: Color(0xFF1B278D),
  });

  static const int _colorPrimaryValue = 0xFF3F51B5;

  static ThemeData lightTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: primarySwatch,
    brightness: Brightness.light,
    primaryColor: AppColor.darkBlue,
    focusColor: AppColor.darkBlue,
    hintColor: AppColor.grey,
    fontFamily: GoogleFonts.inter().fontFamily,
    iconTheme: const IconThemeData(color: AppColor.darkBlue),

    //appBarTheme: const AppBarTheme(),

    navigationDrawerTheme: const NavigationDrawerThemeData(
      backgroundColor: AppColor.grey,
      indicatorColor: AppColor.black,
      elevation: 10
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColor.white,
      elevation: 0,
      selectedItemColor: AppColor.darkBlue,
      unselectedItemColor: AppColor.grey,
    ),


  );
}
