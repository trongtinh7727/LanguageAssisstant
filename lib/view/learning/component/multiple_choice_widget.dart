import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_tts.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';

class MultipleChoiceWidget extends StatefulWidget {
  MultipleChoiceWidget({
    Key? key,
    required this.learningViewModel,
    required this.textContent,
    required this.textEditingController,
  }) : super(key: key);

  final LearningViewModel learningViewModel;
  final String textContent;
  final TextEditingController textEditingController;

  @override
  _MultipleChoiceWidgetState createState() => _MultipleChoiceWidgetState();
}

class _MultipleChoiceWidgetState extends State<MultipleChoiceWidget> {
  Color backgroundColor = AppStyle.activeText;
  Color fillColor = AppStyle.tabUnselectedColor;

  Future<void> speak() async {
    AppTTS.speak(widget.learningViewModel.currentWord.english ?? "vietnamese");
  }

  Future<void> mark() async {
    widget.learningViewModel.currentWord.isMarked =
        !widget.learningViewModel.currentWord.isMarked;
    widget.learningViewModel.markWord(FirebaseAuth.instance.currentUser!.uid);
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

  @override
  Widget build(BuildContext context) {
    final bool isNextButtonEnabled = (widget.learningViewModel.currentIndex <
            widget.learningViewModel.words.length) &&
        (widget.learningViewModel.currentWord.isCorrect != null);

    Color getIconColor() {
      return isNextButtonEnabled ? AppStyle.activeText : AppStyle.lightText;
    }

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
                    Column(
                      children: widget.learningViewModel.currentOptions
                          .map((option) => buildOption(context, option))
                          .toList(),
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

  Widget buildOption(BuildContext context, WordModel option) {
    final String answer = widget.learningViewModel.isEnglishMode
        ? option.vietnamese!
        : option.english!;
    Color fillColor = getColorOption(option);
    return GestureDetector(
      onTap: () => onClickOption(option),
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              answer,
              style: AppStyle.title,
            )
          ],
        ),
      ),
    );
  }

  onClickOption(WordModel option) {
    setState(() {
      if (widget.learningViewModel.currentWord.isCorrect == null) {
        String answer, correctAnswer;
        if (widget.learningViewModel.isEnglishMode) {
          answer = option.vietnamese!;
          correctAnswer = widget.learningViewModel.currentWord.vietnamese!;
        } else {
          answer = option.vietnamese!;
          correctAnswer = widget.learningViewModel.currentWord.vietnamese!;
        }
        final isCorrect = answer.compareTo(correctAnswer) == 0;
        widget.learningViewModel.currentWord.answer = answer;
        widget.learningViewModel.currentWord.isCorrect = isCorrect;
        Future.delayed(Duration(seconds: 1), handleNextButtonTap);
      }
    });
  }

  Color getColorOption(WordModel option) {
    String answer, correctAnswer;
    if (widget.learningViewModel.isEnglishMode) {
      answer = option.vietnamese!;
      correctAnswer = widget.learningViewModel.currentWord.vietnamese!;
    } else {
      answer = option.vietnamese!;
      correctAnswer = widget.learningViewModel.currentWord.vietnamese!;
    }

    final isCorrect = answer.compareTo(correctAnswer) == 0;
    if (widget.learningViewModel.currentWord.isCorrect != null) {
      if (widget.learningViewModel.currentWord.answer! == answer) {
        return isCorrect ? AppStyle.passColor : AppStyle.failedColor;
      } else if (isCorrect) {
        return AppStyle.passColor;
      }
    }
    return Colors.white;
  }
}
