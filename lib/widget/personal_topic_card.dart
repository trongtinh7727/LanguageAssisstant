import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/widget/custom_button.dart';

class TopicCard extends StatelessWidget {
  final TopicModel topic;
  final String word;
  final VoidCallback onContinue;

  const TopicCard(
      {Key? key,
      required this.topic,
      required this.onContinue,
      this.word = 'Chi tiết'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int wordLearned = topic.wordLearned;
    final int wordCount = topic.wordCount;
    final int viewCount = topic.viewCount;
    String wordProgress = "$wordCount";

    if (topic.wordLearned >= 0) {
      wordProgress = "$wordLearned/$wordCount";
    }
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: AppStyle.primaryColor, width: 2)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic.title,
                    style: AppStyle.body2_bold,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (topic.lastAccess != 0)
                  Text(
                    DateTimeUtil.getDateFromTimestamp(topic.lastAccess),
                    style: AppStyle.caption,
                  )
                else
                  Text(
                    DateTimeUtil.getDateFromTimestamp(topic.createTime),
                    style: AppStyle.caption,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  '$wordProgress words',
                  style: AppStyle.caption,
                ),
                const SizedBox(
                  width: 8,
                ),
                if (topic.wordLearned < 0)
                  Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppStyle.primaryColor,
                    size: 16,
                  ),
                if (topic.wordLearned < 0)
                  Text(
                    '$viewCount',
                    style: AppStyle.caption,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            if (topic.wordLearned >= 0)
              SizedBox(
                width: 150,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: topic.wordLearned / topic.wordCount,
                    minHeight: 7,
                    backgroundColor: Colors.blue[100],
                    color: Colors.blue,
                  ),
                ),
              ),
            if (topic.wordLearned >= 0) const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(topic.authoravatar ??
                          'https://firebasestorage.googleapis.com/v0/b/language-assistant-7727.appspot.com/o/Users%2FAvatars%2Favatar_default.png?alt=media&token=490b3731-c6a2-4d1b-a75a-4902372c307b'),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Log the error, show a dialog, or use a fallback image
                        print('Error loading background image: $exception');
                      },
                      child: topic.authoravatar == null
                          ? const Icon(Icons
                              .person) // Fallback icon in case the URL is null
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      topic.authorName ?? "",
                      style: AppStyle.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                CustomButton(
                  onContinue: onContinue,
                  btnBackground: word.compareTo('Xóa') == 0
                      ? AppStyle.failedColor
                      : Colors.black,
                  word: word,
                  textColor: word.compareTo('Xóa') == 0
                      ? AppStyle.redColor
                      : AppStyle.activeText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
