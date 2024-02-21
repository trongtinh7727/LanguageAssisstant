import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:languageassistant/model/models/word_model.dart';

import 'package:languageassistant/utils/app_style.dart';
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
    await flutterTts.setLanguage(
        "en-US"); // Set the language to Vietnamese (adjust as needed)
    await flutterTts.speak(word.english ?? "vietnamese");
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
                if (word.isMarked)
                  InkWell(
                    onTap: () {
                      _mark();
                    },
                    child: Icon(
                      Icons.star_purple500_sharp,
                      color: AppStyle.redColor,
                    ),
                  )
                else
                  InkWell(
                    onTap: () {
                      _mark();
                    },
                    child: const Icon(Icons.star_border_outlined),
                  ),
                InkWell(
                  onTap: _speak, // Call the speak method when tapped
                  child: const Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              word.vietnamese ?? "vietnamese",
              style: AppStyle.body2,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
