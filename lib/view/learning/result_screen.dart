import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view/learning/component/fillter_menu.dart';
import 'package:languageassistant/view/learning/component/learning_progress.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/widget/word_item.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late LearningViewModel learningViewModel;
  final flipCardController = FlipCardController();
  Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    learningViewModel = Provider.of<LearningViewModel>(context);
    final percent = learningViewModel.masteredWords.length /
        (learningViewModel.masteredWords.length +
            learningViewModel.learnedWords.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá'),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                learningViewModel.topic.title,
                style: AppStyle.title,
              ),
              Text(
                'Chúc mừng bạn đã hoàn thành bài học!',
                style: AppStyle.body2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Tổng điểm: ',
                    style: AppStyle.title,
                  )
                ],
              ),
              CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 13.0,
                animation: true,
                percent: percent,
                center: Text(
                  "${(percent * 100).toStringAsFixed(2)}%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: percent >= 0.5
                    ? AppStyle.successColor
                    : AppStyle.warningColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Lịch sử làm bài: ',
                    style: AppStyle.title,
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(children: [
                for (final word in learningViewModel.learnedWords)
                  WordItem(
                    word: word,
                    backgroundColor:
                        learningViewModel.learningMode == LearningMode.FlashCard
                            ? AppStyle.warningColor
                            : AppStyle.failedColor,
                  ),
                for (final word in learningViewModel.masteredWords)
                  WordItem(
                    word: word,
                    backgroundColor: AppStyle.passColor,
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
