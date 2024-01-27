import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onContinue,
    required this.word,
  });

  final VoidCallback onContinue;
  final String word;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: ElevatedButton(
        onPressed: onContinue,
        child: Text(
          word,
          style: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: primaryColor, width: 2)),
        ),
      ),
    );
  }
}
