import 'package:flutter/material.dart';
import '../values/colors.dart';

class AppTheme {
  static final defaultTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'Bold',
        color: ColorSys.text_title_color_lighte,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'regular',
        color: ColorSys.text_title_color_lighte,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    ),
  );
}
