import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/utils/date_time_util.dart';
import 'package:languageassistant/view/topic_detail/topic_detail_screen.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:provider/provider.dart';

class TopicInformation extends StatelessWidget {
  const TopicInformation({
    super.key,
    required this.widget,
    required this.viewCount,
    required this.wordProgress,
    required this.topicViewModel,
  });

  final TopicDetailScreen widget;
  final TopicViewModel topicViewModel;
  final int viewCount;
  final String wordProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topicViewModel.topic!.title,
            maxLines: 5,
            style: AppStyle.headline,
          ),
          Row(
            children: [
              Text(
                '${DateTimeUtil.format(topicViewModel.topic!.createTime)}',
                style: AppStyle.caption,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.remove_red_eye_outlined,
                color: AppStyle.primaryColor,
                size: 16,
              ),
              Text(
                '$viewCount',
                style: AppStyle.caption,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '$wordProgress words',
            style: AppStyle.caption,
          ),
          SizedBox(
            height: 8,
          ),
          if (topicViewModel.topic!.wordLearned >= 0)
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: topicViewModel.topic!.wordLearned /
                      topicViewModel.topic!.wordCount,
                  minHeight: 7,
                  backgroundColor: Colors.blue[100],
                  color: Colors.blue,
                ),
              ),
            ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(topicViewModel
                        .topic!.authoravatar ??
                    'https://firebasestorage.googleapis.com/v0/b/language-assistant-7727.appspot.com/o/Users%2FAvatars%2Favatar_default.png?alt=media&token=490b3731-c6a2-4d1b-a75a-4902372c307b'),
                onBackgroundImageError: (exception, stackTrace) {
                  // Log the error, show a dialog, or use a fallback image
                  print('Error loading background image: $exception');
                },
                child: topicViewModel.topic!.authoravatar == null
                    ? Icon(
                        Icons.person) // Fallback icon in case the URL is null
                    : null,
              ),
              SizedBox(width: 8),
              Text(
                topicViewModel.topic!.authorName ?? "",
                style: AppStyle.caption,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Căn giữa và đều các nút
            children: [
              CustomButton(
                onContinue: () {
                  final learningViewModel =
                      Provider.of<LearningViewModel>(context, listen: false);
                  learningViewModel.setTopic(
                      topicViewModel.topic!, LearningMode.FlashCard);

                  learningViewModel.fetchWordsByStatus(
                      FirebaseAuth.instance.currentUser!.uid,
                      topicViewModel.topic!.id,
                      WordStatus.ALL);
                  Navigator.pushNamed(context, RouteName.flashCardScreen);
                },
                word: "Flashcard",
                btnBackground: Colors.white,
                textColor: AppStyle.activeText,
              ),
              CustomButton(
                onContinue: () {
                  final learningViewModel =
                      Provider.of<LearningViewModel>(context, listen: false);
                  learningViewModel.setTopic(
                      topicViewModel.topic!, LearningMode.WordType);
                  learningViewModel.fetchWordsByStatus(
                      FirebaseAuth.instance.currentUser!.uid,
                      topicViewModel.topic!.id,
                      WordStatus.ALL);
                  Navigator.pushNamed(context, RouteName.wordTypeScreen);
                },
                word: "Điền từ",
                btnBackground: Colors.white,
                textColor: AppStyle.activeText,
              ),
              CustomButton(
                onContinue: () {
                  final learningViewModel =
                      Provider.of<LearningViewModel>(context, listen: false);
                  learningViewModel.setTopic(
                      topicViewModel.topic!, LearningMode.MultipleChoice);
                  learningViewModel.fetchWordsByStatus(
                      FirebaseAuth.instance.currentUser!.uid,
                      topicViewModel.topic!.id,
                      WordStatus.ALL);

                  Navigator.pushNamed(context, RouteName.multipleChoiceScreen);
                },
                word: "MCQ",
                btnBackground: Colors.white,
                textColor: AppStyle.activeText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
