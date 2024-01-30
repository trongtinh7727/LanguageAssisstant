import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/utils/app_color.dart';

class WordItem extends StatelessWidget {
  final WordModel word;
  final Color backgroundColor;

  WordItem({
    Key? key,
    required this.word,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak() async {
    await flutterTts.setLanguage(
        "en-US"); // Set the language to Vietnamese (adjust as needed)
    await flutterTts.speak(word.english ?? "vietnamese");
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: false,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (word.isMarked)
                  InkWell(
                    onTap: () {
                      print('Star tapped!');
                    },
                    child: Icon(
                      Icons.star_purple500_sharp,
                      color: redColor,
                    ),
                  )
                else
                  InkWell(
                    onTap: () {
                      print('Star tapped!');
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
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 80, 71, 71),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
