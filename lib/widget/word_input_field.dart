import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/word_model.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/widget/text_field_widget.dart';

class WordInputField extends StatefulWidget {
  final WordModel word;
  final VoidCallback onDelete;
  WordInputField({Key? key, required this.word, required this.onDelete})
      : super(key: ValueKey(word.id));

  @override
  _WordInputFieldState createState() => _WordInputFieldState();
}

class _WordInputFieldState extends State<WordInputField> {
  late TextEditingController _englishController;
  late TextEditingController _vietnameseController;

  @override
  void initState() {
    super.initState();
    _englishController = TextEditingController(text: widget.word.english);
    _vietnameseController = TextEditingController(text: widget.word.vietnamese);

    _englishController.addListener(_onEnglishChanged);
    _vietnameseController.addListener(_onVietnameseChanged);
  }

  void _onEnglishChanged() {
    setState(() {
      widget.word.english = _englishController.text;
    });
  }

  void _onVietnameseChanged() {
    setState(() {
      widget.word.vietnamese = _vietnameseController.text;
    });
  }

  @override
  void dispose() {
    _englishController.removeListener(_onEnglishChanged);
    _vietnameseController.removeListener(_onVietnameseChanged);
    _englishController.dispose();
    _vietnameseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppStyle.tabUnselectedColor),
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Thuật ngữ",
                  style: AppStyle.body2_bold,
                ),
                InkWell(
                  onTap: widget.onDelete,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextFieldWidget(
              hint: "Thuật ngữ (English)",
              textEditingController: _englishController),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              const Text(
                "Định nghĩa",
                style: AppStyle.body2_bold,
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFieldWidget(
              hint: 'Định nghĩa (Vietnamese)',
              textEditingController: _vietnameseController),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
