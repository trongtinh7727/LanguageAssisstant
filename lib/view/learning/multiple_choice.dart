import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/view/learning/component/fillter_menu.dart';
import 'package:languageassistant/view/learning/component/learning_progress.dart';
import 'package:languageassistant/view/learning/component/multiple_choice_widget.dart';
import 'package:languageassistant/view/learning/component/word_type_widget.dart';
import 'package:languageassistant/view_model/learning_view_model.dart';
import 'package:provider/provider.dart';

class MultipleChoice extends StatefulWidget {
  final TopicModel? editTopicModel;

  const MultipleChoice({super.key, this.editTopicModel});
  @override
  _MultipleChoiceState createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
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
              MultipleChoiceWidget(
                  learningViewModel: learningViewModel,
                  textContent: textContent,
                  textEditingController: textEditingController),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ));
  }
}
