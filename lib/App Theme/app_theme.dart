import 'package:flutter/material.dart';

class ColorsForApp{


  static Color blackColor = HexColor("#000000");
  static Color whiteColor = HexColor("#FFFFFF");
  static Color grayColor = HexColor("#D9D9D9");
  static Color grayLabelColor = HexColor("#D6D6D6");
  static Color appButtonColor = HexColor("#BD1D38");


}
class StyleForApp{

  static  TextStyle headline = TextStyle(
    //fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle subHeadline = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle textStyle20dp = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w300,
    fontSize: 20,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );static  TextStyle textStyle15dp = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w300,
    fontSize: 15,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle textStyle20dpBold = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle textStyle16dpBold = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle appBarTextStyle = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );

  static  TextStyle textStyle14dp = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w300,
    fontSize: 14,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
  static  TextStyle extraSmaller12dp = TextStyle(
   // fontFamily: fontName,
    fontWeight: FontWeight.w300,
    fontSize: 12,
    letterSpacing: 0.27,
    color: ColorsForApp.blackColor,
  );
}
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}