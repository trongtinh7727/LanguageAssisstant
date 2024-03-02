import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_tts.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/text_field_widget.dart';

class WordTypeWidget extends StatefulWidget {
  WordTypeWidget({
    Key? key,
    required this.learningViewModel,
    required this.textContent,
    required this.textEditingController,
  }) : super(key: key);

  final LearningViewModel learningViewModel;
  final String textContent;
  final TextEditingController textEditingController;

  @override
  _WordTypeWidgetState createState() => _WordTypeWidgetState();
}

class _WordTypeWidgetState extends State<WordTypeWidget> {
  Color backgroundColor = AppStyle.activeText;
  Color fillColor = AppStyle.tabUnselectedColor;
  bool isFailed = false;
  bool isEnabled = true;

  Future<void> speak() async {
    AppTTS.speak(widget.learningViewModel.currentWord.english ?? "vietnamese");
  }

  Future<void> mark() async {
    widget.learningViewModel.currentWord.isMarked =
        !widget.learningViewModel.currentWord.isMarked;
    widget.learningViewModel.markWord(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final String answer = widget.learningViewModel.isEnglishMode
        ? widget.learningViewModel.currentWord.vietnamese!
        : widget.learningViewModel.currentWord.english!;

    final bool isNextButtonEnabled = (widget.learningViewModel.currentIndex <
            widget.learningViewModel.words.length) &&
        (widget.learningViewModel.currentWord.isCorrect != null);

    Color getIconColor() {
      return isNextButtonEnabled ? AppStyle.activeText : AppStyle.lightText;
    }

    void handleNextButtonTap() {
      if (widget.learningViewModel.currentWord.isCorrect != null) {
        widget.learningViewModel.currentWord.isCorrect!
            ? widget.learningViewModel.showNextCard(
                isMastered: true,
                context: context,
              )
            : widget.learningViewModel.showNextCard(
                isMastered: false,
                context: context,
              );
      }
    }

    void checkAnswer() {
      final message = Validator.required(
          value: widget.textEditingController.text,
          message: 'Vui lòng nhập câu trả lời!');
      if (message == null) {
        final userAnswer =
            widget.textEditingController.text.toLowerCase().trim();
        final correctAnswer = answer.toLowerCase().trim();
        final isCorrect = userAnswer == correctAnswer;
        setState(() {
          widget.learningViewModel.currentWord.answer =
              widget.textEditingController.text;
          widget.learningViewModel.currentWord.isCorrect = isCorrect;
          isFailed = !isCorrect;
          isEnabled = false;
          fillColor = isCorrect ? AppStyle.passColor : AppStyle.failedColor;
          backgroundColor =
              isCorrect ? AppStyle.successColor : AppStyle.redColor;
        });
      } else {
        commonToast(message);
      }
    }

    void checkAnswered() {
      if (widget.learningViewModel.currentWord.answer != null) {
        widget.textEditingController.text =
            widget.learningViewModel.currentWord.answer!;
        checkAnswer();
      } else {
        setState(() {
          widget.textEditingController.text = '';
          backgroundColor = AppStyle.activeText;
          fillColor = AppStyle.tabUnselectedColor;
          isFailed = false;
          isEnabled = true;
        });
      }
    }

    checkAnswered();

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppStyle.primaryColor, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 340,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: mark,
                          child: Icon(
                            widget.learningViewModel.currentWord.isMarked
                                ? Icons.star_purple500_sharp
                                : Icons.star_border_outlined,
                            color: widget.learningViewModel.currentWord.isMarked
                                ? AppStyle.redColor
                                : AppStyle.darkText,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: speak,
                          child: Icon(
                            Icons.volume_up_rounded,
                            color: AppStyle.darkText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Text(
                      widget.textContent,
                      style: AppStyle.headline,
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    TextFieldWidget(
                      isEnabled: isEnabled,
                      fillColor: fillColor,
                      textEditingController: widget.textEditingController,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (isFailed)
                      TextFieldWidget(
                        isEnabled: false,
                        fillColor: AppStyle.passColor,
                        textColor: AppStyle.successColor,
                        textEditingController:
                            TextEditingController(text: answer),
                      ),
                    if (isFailed)
                      SizedBox(
                        height: 10,
                      ),
                    CustomButton(
                      onContinue: () {
                        checkAnswer();
                        Future.delayed(
                            Duration(seconds: 1), handleNextButtonTap);
                      },
                      word: 'Kiểm tra',
                      btnBackground: backgroundColor,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: widget.learningViewModel.showPreviousCard,
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: widget.learningViewModel.currentIndex > 0
                        ? AppStyle.activeText
                        : AppStyle.lightText,
                    size: 35,
                  ),
                ),
                InkWell(
                  onTap: () {
                    handleNextButtonTap();
                  },
                  child: Icon(
                    Icons.arrow_circle_right_outlined,
                    color: getIconColor(),
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
