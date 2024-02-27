import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_tts.dart';

import 'package:languageassistant/view_model/learning_view_model.dart';

class FlashCardWidget extends StatelessWidget {
  FlashCardWidget(
      {super.key,
      required this.learningViewModel,
      required bool this.isFont,
      this.backgroundColor = Colors.black});
  final LearningViewModel learningViewModel;
  final bool isFont;
  final Color backgroundColor;
  final FlutterTts flutterTts = FlutterTts();
  Future<void> speak() async {
    AppTTS.speak(learningViewModel.currentWord.english ?? "vietnamese");
  }

  Future<void> mark() async {
    learningViewModel.currentWord.isMarked =
        !learningViewModel.currentWord.isMarked;
    learningViewModel.markWord(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    String textContent = learningViewModel.isEnglishMode
        ? (isFont
            ? learningViewModel.currentWord.english ?? ""
            : learningViewModel.currentWord.vietnamese ?? "")
        : (isFont
            ? learningViewModel.currentWord.vietnamese ?? ""
            : learningViewModel.currentWord.english ?? "");

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: AppStyle.primaryColor, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 340,
          height: 445,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: mark,
                      child: Icon(
                        learningViewModel.currentWord.isMarked
                            ? Icons.star_purple500_sharp
                            : Icons.star_border_outlined,
                        color: learningViewModel.currentWord.isMarked
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
                Expanded(
                  child: Center(
                      child: Text(
                    textContent,
                    style: AppStyle.display1,
                  )),
                ),
                Text(
                  'Nhấn vào thẻ để lật',
                  style: AppStyle.active,
                ),
                // Add more widgets here for your content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
