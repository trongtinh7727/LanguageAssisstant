import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onContinue,
    required this.word,
    this.btnBackground = Colors.black, // Giá trị mặc định cho buttonBackColor
  });

  final VoidCallback onContinue;
  final String word;
  final Color btnBackground; // Tham số tùy chọn cho màu nền của nút

  @override
  Widget build(BuildContext context) {
    Color btnBack = buttonBackColor;
    if (btnBackground != Colors.black) {
      btnBack = btnBackground;
    }
    return SizedBox(
      width: 108,
      child: ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnBack, // Sử dụng giá trị buttonBackColor
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: primaryColor, width: 2),
          ),
        ),
        child: Text(
          word,
          style: TextStyle(
            color: buttonTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
