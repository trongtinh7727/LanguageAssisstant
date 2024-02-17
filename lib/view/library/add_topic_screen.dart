import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:languageassistant/widget/word_input_field.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTopicScreen extends StatefulWidget {
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  // List of text controllers for each field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _titleController = TextEditingController();
  final List<WordModel> _words = [];
  final Random _random = Random();
  void _addTermField() {
    tz.TZDateTime nowInTimeZone =
        tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
    int currentTimesnap = (nowInTimeZone.millisecondsSinceEpoch / 1000).toInt();
    setState(() {
      _words.add(WordModel(
          id: _generateUniqueId(),
          createTime: currentTimesnap,
          updateTime: currentTimesnap));
    });
  }

  String _generateUniqueId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomValue = _random.nextInt(1000);
    return 'w$timestamp$randomValue';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicViewModel = Provider.of<TopicViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Topic'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Tiêu đề",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            TextFieldWidget(
                fillColor: tabUnselectedColor,
                paddingH: 5,
                hint: 'Tiêu đề',
                textEditingController: _titleController),
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Từ vựng",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _words.length,
              itemBuilder: (context, index) {
                final word = _words[index];
                return WordInputField(
                    word: word, onDelete: () => _removeWord(word));
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: _addTermField,
              tooltip: 'Thêm thuật ngữ',
            ),
            ElevatedButton(
              onPressed: () => _saveAndShowWords(topicViewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                fixedSize: Size(295, 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: topicViewModel.isLoading
                  ? CircularProgressIndicator(
                      color: whiteColor,
                    )
                  : Text('Lưu', style: TextStyle(color: whiteColor)),
            ),
          ],
        ),
      ),
    );
  }

  void _removeWord(WordModel wordModel) {
    setState(() {
      _words.removeWhere((word) => word.id == wordModel.id);
    });
  }

  void _saveAndShowWords(TopicViewModel topicViewModel) async {
    tz.TZDateTime nowInTimeZone =
        tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
    int currentTimesnap = (nowInTimeZone.millisecondsSinceEpoch / 1000).toInt();
    TopicModel _topic = TopicModel(
        id: "",
        title: _titleController.value.text,
        description: '',
        wordCount: _words.length,
        viewCount: 0,
        public: false,
        author: _auth.currentUser!.uid,
        createTime: currentTimesnap,
        updateTime: currentTimesnap);
    try {
      final addedTopic = await topicViewModel.createTopic(_topic, _words);
      topicViewModel.fetchWordsByStatus(
          _auth.currentUser!.uid, addedTopic.id, WordStatus.ALL);
      topicViewModel.fetchLeaderBoard(addedTopic.id);
      Navigator.pushNamed(context, RouteName.topicDetailScreen,
          arguments: addedTopic);
    } catch (e) {
      print("Error saving topic: $e");
      // Handle the error, maybe show a dialog to the user.
    }
  }
}
