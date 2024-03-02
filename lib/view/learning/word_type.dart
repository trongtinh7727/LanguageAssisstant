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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
            ],
          ),
        ));
  }
}
