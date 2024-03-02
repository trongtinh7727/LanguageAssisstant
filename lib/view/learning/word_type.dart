import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view/learning/component/fillter_menu.dart';
import 'package:languageassistant/view/learning/component/learning_progress.dart';
import 'package:languageassistant/view/learning/component/word_type_widget.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:provider/provider.dart';

class WordTypeScreen extends StatefulWidget {
  final TopicModel? editTopicModel;

  const WordTypeScreen({super.key, this.editTopicModel});
  @override
  _WordTypeScreenState createState() => _WordTypeScreenState();
}

class _WordTypeScreenState extends State<WordTypeScreen> {
  late LearningViewModel learningViewModel;
  final flipCardController = FlipCardController();
  Color cardColor = Colors.white; // Màu ban đầu của card
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    learningViewModel = Provider.of<LearningViewModel>(context);
    String textContent = learningViewModel.isEnglishMode
        ? learningViewModel.currentWord.english ?? ""
        : learningViewModel.currentWord.vietnamese ?? "";

    final bool isNextButtonEnabled =
        (learningViewModel.currentIndex < learningViewModel.words.length) &&
            (learningViewModel.currentWord.isCorrect != null);

    Color getIconColor() {
      return isNextButtonEnabled ? AppStyle.activeText : AppStyle.lightText;
    }

    void handleNextButtonTap() {
      if (learningViewModel.currentWord.isCorrect != null) {
        learningViewModel.currentWord.isCorrect!
            ? learningViewModel.showNextCard(
                isMastered: true,
                context: context,
              )
            : learningViewModel.showNextCard(
                isMastered: false,
                context: context,
              );
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Điền từ'),
          actions: [FillterMenu(learningViewModel: learningViewModel)],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              LearningProgress(learningViewModel: learningViewModel),
              SizedBox(
                height: 30,
              ),
              WordTypeWidget(
                  learningViewModel: learningViewModel,
                  textContent: textContent,
                  textEditingController: textEditingController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: learningViewModel.showPreviousCard,
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: learningViewModel.currentIndex > 0
                              ? AppStyle.activeText
                              : AppStyle.lightText,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          handleNextButtonTap();
                        },
                        child: Icon(
                          Icons.arrow_circle_right_outlined,
                          color: getIconColor(),
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ));
  }
}
