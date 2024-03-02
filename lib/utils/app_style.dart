import 'package:flutter/material.dart';

class AppStyle {
  static const String fontName =
      'WorkSans'; // Thay đổi tên font chữ theo font bạn muốn sử dụng

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color activeText = Color.fromARGB(255, 0, 75, 185);

  static const Color primaryColor = Color(0xFF3A94E7);
  static const Color buttonBackColor = Color(0xFFE6EDF8);
  static const Color buttonTextColor = Color(0xFF004AB9);
  static const Color textFieldColor = Color(0xFFD1D1D1);
  static const Color tabUnselectedColor = Color(0xFFDFE9F8);
  static const Color greenBlurColor = Color.fromARGB(255, 193, 253, 191);
  static const Color greyColor_100 = Color(0xFFDEE0E5);
  static const Color redColor = Color(0xFFFF0000);
  static const Color successColor = Color(0xFF05B305);
  static const Color warningColor = Color(0xFFD4B511);
  static const Color failedColor = Color(0xFFFBD6D8);
  static final Color passColor = Color(0xffd7fdd8);

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );
  static const TextStyle body2_bold = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );
  static const TextStyle active = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    // letterSpacing: 0.2,
    color: activeText,
  );

  static const TextStyle activeWhite = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    // letterSpacing: 0.2,
    color: Colors.white,
  );
  static const TextStyle successText = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    // letterSpacing: 0.2,
    color: successColor,
  );
  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText,
  );

  static const TextStyle dateTime = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 10,
    letterSpacing: 0.2,
    color: lightText,
  );

  static ThemeData getTheme() {
    return ThemeData(
      textTheme: textTheme,
      fontFamily: fontName,
      primarySwatch: Colors.blue,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    );
  }
}
