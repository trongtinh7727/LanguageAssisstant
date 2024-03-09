import 'package:flutter/material.dart';

import 'package:languageassistant/utils/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      this.width = 120,
      this.height = 40,
      required this.onContinue,
      required this.word,
      this.btnBackground = Colors.black,
      this.textColor = AppStyle.activeText});
  final double width;
  final double height;
  final VoidCallback onContinue;
  final String word;
  final Color btnBackground;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    Color btnBack = AppStyle.buttonBackColor;
    Color textFillColor = AppStyle.activeText;
    if (btnBackground != Colors.black) {
      btnBack = btnBackground;
    }
    if (textColor != AppStyle.activeText) {
      textFillColor = textColor;
    }
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnBack, // Sử dụng giá trị buttonBackColor
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: textFillColor, width: 2),
          ),
        ),
        child: Text(
          word,
          style: TextStyle(
            color: textFillColor,
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
