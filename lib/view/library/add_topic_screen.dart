import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_icons.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/add_topic_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/bottomsheet_widget.dart';
import 'package:languageassistant/widget/text_field_widget.dart';
import 'package:languageassistant/widget/word_input_field.dart';
import 'package:provider/provider.dart';

class AddTopicScreen extends StatefulWidget {
  final TopicModel? editTopicModel;

  const AddTopicScreen({super.key, this.editTopicModel});
  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _titleController = TextEditingController();
  late AddTopicViewModel _addTopicViewModel;

  @override
  void initState() {
    super.initState();
    _addTopicViewModel = Provider.of<AddTopicViewModel>(context, listen: false);
    if (widget.editTopicModel == null) {
      _addTopicViewModel.clearWords();
    } else {
      _titleController.text = widget.editTopicModel!.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _addTopicViewModel = Provider.of<AddTopicViewModel>(context);

    void _showModalBottomSheet(BuildContext context) {
      BottomSheetItem _bottomSheet = BottomSheetItem(
        icon: Icon(LAIcons.import, color: Colors.black),
        onTap: () {
          _addTopicViewModel.pickFile();
          Navigator.pop(context);
        },
        text: "Thêm bằng file CSV",
      );

      showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return BottomSheetWidget(
            bottomSheetItems: Column(children: [_bottomSheet]),
            menuItemCount: 1,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Topic'),
        actions: [
          IconButton(
            onPressed: () => _showModalBottomSheet(context),
            icon: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Tiêu đề",
                  style: AppStyle.title,
                ),
              ],
            ),
            TextFieldWidget(
              fillColor: AppStyle.tabUnselectedColor,
              paddingH: 5,
              hint: 'Tiêu đề',
              textEditingController: _titleController,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Từ vựng",
                  style: AppStyle.title,
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _addTopicViewModel.words.length,
              itemBuilder: (context, index) {
                final word = _addTopicViewModel.words[index];
                return WordInputField(
                  word: word,
                  onDelete: () => _addTopicViewModel.removeWord(word),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: _addTopicViewModel.addEmptyTermField,
              tooltip: 'Thêm thuật ngữ',
            ),
            ElevatedButton(
              onPressed: () => _saveAndShowWords(_addTopicViewModel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primaryColor,
                fixedSize: const Size(300, 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: _addTopicViewModel.isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Lưu',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndShowWords(AddTopicViewModel addTopicViewModel) async {
    try {
      var addedTopic;
      if (widget.editTopicModel != null) {
        addedTopic = await addTopicViewModel.saveAndShowWords(
            _titleController.value.text,
            _auth.currentUser!.uid,
            widget.editTopicModel);
      } else {
        addedTopic = await addTopicViewModel.saveAndShowWords(
            _titleController.value.text, _auth.currentUser!.uid, null);
      }
      final topicViewModel =
          Provider.of<TopicViewModel>(context, listen: false);
      if (addedTopic != null) {
        topicViewModel.fetchWordsByStatus(
            _auth.currentUser!.uid, addedTopic.id, WordStatus.ALL);
        topicViewModel.fetchLeaderBoard(addedTopic.id);
        // Navigator.pop(context);
        Navigator.pushReplacementNamed(context, RouteName.topicDetailScreen,
            arguments: addedTopic);
      }
    } catch (e) {
      print("Error saving topic: $e");
      // Handle the error, maybe show a dialog to the user.
    }
  }
}
