import 'package:flutter/material.dart';

import 'package:languageassistant/utils/app_style.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.width = 120,
    this.height = 40,
    required this.onContinue,
    required this.word,
    this.btnBackground = Colors.black, // Giá trị mặc định cho buttonBackColor
  });
  final double width;
  final double height;
  final VoidCallback onContinue;
  final String word;
  final Color btnBackground; // Tham số tùy chọn cho màu nền của nút

  @override
  Widget build(BuildContext context) {
    Color btnBack = AppStyle.buttonBackColor;
    if (btnBackground != Colors.black) {
      btnBack = btnBackground;
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
            side: BorderSide(color: AppStyle.primaryColor, width: 2),
          ),
        ),
        child: Text(
          word,
          style: (btnBack == AppStyle.activeText)
              ? AppStyle.activeWhite
              : AppStyle.active,
        ),
      ),
    );
  }
}
