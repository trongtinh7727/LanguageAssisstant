import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';

class TextFieldWidget extends StatefulWidget {
  final String hint;
  final String? Function(String?)? validator;
  final IconData? icon;
  final bool isPassword;
  final Color fillColor;
  final Color textColor;
  final double paddingH;
  final bool isEnabled;
  final TextEditingController textEditingController;

  const TextFieldWidget({
    Key? key,
    this.validator,
    this.hint = "",
    this.icon,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.paddingH = 20.0,
    required this.textEditingController,
    this.isPassword = false,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.paddingH),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 500), // Set your desired max width here
        child: TextFormField(
          validator: widget.validator,
          autofocus: true,
          readOnly: !widget.isEnabled,
          controller: widget.textEditingController,
          maxLines: 1,
          obscureText: _isPasswordVisible,
          style: TextStyle(
            fontFamily: 'WorkSans',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0.2,
            color: widget.textColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppStyle.caption,
            prefixIcon: widget.icon != null
                ? Icon(widget.icon, color: Colors.black54)
                : null, // Conditional prefixIcon
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: widget.fillColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppStyle.activeText),
            ),
          ),
        ),
      ),
    );
  }
}
