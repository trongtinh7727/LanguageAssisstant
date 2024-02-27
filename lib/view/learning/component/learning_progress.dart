import 'package:flutter/material.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';

class LearningProgress extends StatelessWidget {
  const LearningProgress({
    super.key,
    required this.learningViewModel,
  });

  final LearningViewModel learningViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          learningViewModel.topic.title,
          style: AppStyle.title,
          textAlign: TextAlign.center,
        )),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chưa TT: ${learningViewModel.learnedWords.length}',
              style: TextStyle(
                  color: AppStyle.warningColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            Text(
              '${learningViewModel.currentIndex}/${learningViewModel.words.length}',
              style: TextStyle(
                  color: AppStyle.darkText,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            Text(
              'Đã TT: ${learningViewModel.masteredWords.length}',
              style: TextStyle(
                  color: AppStyle.successColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
