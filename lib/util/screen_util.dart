import 'package:flutter/cupertino.dart';

class ScreenUtil {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static double fontSizeSmall = screenWidth*5;
  static double fontSizeMedium = screenWidth*8;
  static double fontSizeLarge = screenWidth*10;

  ScreenUtil(context) {
    screenHeight = MediaQuery.of(context).size.height / 100;
    screenWidth = MediaQuery.of(context).size.width / 100;
  }
}