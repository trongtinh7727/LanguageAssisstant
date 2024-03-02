import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';

import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/widget/custom_button.dart';

class TopicLeaderBoardItem extends StatelessWidget {
  final String imagePath;
  final TopicModel topic;
  final VoidCallback onContinue;

  const TopicLeaderBoardItem({
    Key? key,
    required this.imagePath,
    required this.topic,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int wordLearned = topic.wordLearned;
    final int wordCount = topic.wordCount;
    final int viewCount = topic.viewCount;
    String wordProgress = "$wordCount";

    if (topic.wordLearned >= 0) {
      wordProgress = "$wordLearned/$wordCount";
    }
    const String word = "Chi Tiết";
    return SizedBox(
      width: 140,
      child: InkWell(
        onTap: onContinue,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: AppStyle.primaryColor, width: 2)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(5), // Adjust the radius here
                  child: Image.asset(
                    imagePath, // Replace with your image path
                    fit: BoxFit.cover, // You can adjust the fit as needed
                  ),
                ),
                Text(
                  topic.title,
                  style: AppStyle.body2_bold,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '$wordProgress words',
                  style: AppStyle.caption,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.remove_red_eye_outlined,
                      color: AppStyle.primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('$viewCount', style: AppStyle.caption),
                  ],
                ),
                const SizedBox(height: 6),
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
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        topic.authorName ?? "",
                        style: AppStyle.caption,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
