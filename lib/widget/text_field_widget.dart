import 'package:flutter/material.dart';

import 'package:languageassistant/utils/app_style.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final Color fillColor;
  final Color textColor;
  final double paddingH;
  final TextEditingController textEditingController;

  const TextFieldWidget({
    Key? key,
    this.hint = "",
    this.icon,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.paddingH = 20.0,
    required this.textEditingController,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingH),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 500), // Set your desired max width here
        child: TextField(
          controller: textEditingController,
          maxLines: 1,
          obscureText: isPassword,
          style: AppStyle.body2,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyle.caption,
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.black54)
                : null, // Conditional prefixIcon

            filled: true,
            fillColor: fillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ),
    );
  }
}
