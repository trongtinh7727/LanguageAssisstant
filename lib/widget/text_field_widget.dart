import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_color.dart';

class TextFieldWidget extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController textEditingController;

  const TextFieldWidget({
    Key? key,
    required this.hint,
    required this.icon,
    required this.textEditingController,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 500), // Set your desired max width here
        child: TextField(
          controller: textEditingController,
          maxLines: 1,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color.fromARGB(179, 48, 44, 44)),
            prefixIcon: Icon(icon, color: Colors.black54),
            filled: true,
            fillColor: textFieldColor,
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
