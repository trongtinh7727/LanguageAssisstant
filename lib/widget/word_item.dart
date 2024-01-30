import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/widget/custom_button.dart';

class WordItem extends StatelessWidget {
  final WordModel word;
  final Color backgroundColor;

  const WordItem({
    Key? key,
    required this.word,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

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
                    style: TextStyle(
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
                    child: Icon(Icons.star_border_outlined),
                  ),
                InkWell(
                  onTap: () {
                    print('Volume tapped!');
                  },
                  child: Icon(Icons.volume_up_rounded),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              word.vietnamese ?? "vietnamese",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
