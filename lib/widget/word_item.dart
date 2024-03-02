import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:languageassistant/model/models/word_model.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/app_tts.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';

class WordItem extends StatelessWidget {
  final WordModel word;
  final Color backgroundColor;
  final String userID;
  final String topicID;
  final TopicViewModel? topicViewModel;

  WordItem({
    Key? key,
    required this.word,
    this.backgroundColor = Colors.white,
    this.topicID = "",
    this.userID = "",
    this.topicViewModel,
  }) : super(key: key);

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak() async {
    AppTTS.speak(word.english ?? "vietnamese");
  }

  Future<void> _mark() async {
    word.isMarked = !word.isMarked;
    topicViewModel?.markWord(topicID, word.id!, userID, word.isMarked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: AppStyle.activeText, width: 1.5), // Đặt màu viền và độ dày
      ),
      color: backgroundColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    word.english ?? "English",
                    style: AppStyle.body2_bold,
                    softWrap: false,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _mark();
                  },
                  child: Icon(
                    word.isMarked
                        ? Icons.star_purple500_sharp
                        : Icons.star_border_outlined,
                    color:
                        word.isMarked ? AppStyle.redColor : AppStyle.darkText,
                  ),
                ),
                InkWell(
                  onTap: _speak, // Call the speak method when tapped
                  child: const Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              word.answer ?? word.vietnamese ?? "vietnamese",
              style: AppStyle.body2,
            ),
            const SizedBox(height: 8),
            if (word.answer != null)
              Row(
                children: [
                  Text(
                    'Đáp án: ',
                    style: AppStyle.body2,
                  ),
                  Text(
                    word.vietnamese ?? '',
                    style: AppStyle.successText,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
