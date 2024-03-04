import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/folder_card_widget.dart';
import 'package:provider/provider.dart';

class AddFoldersToTopic extends StatefulWidget {
  @override
  _AddFoldersToTopicState createState() => _AddFoldersToTopicState();
}

class _AddFoldersToTopicState extends State<AddFoldersToTopic> {
  late TopicViewModel _topicViewModel;
  late FolderViewModel _folderViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _topicViewModel = Provider.of<TopicViewModel>(context, listen: false);
    _folderViewModel = Provider.of<FolderViewModel>(context, listen: false);
  }

  bool _isScrollAtBottom(ScrollNotification notification) {
    return notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm topic vào folder'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // Implement your search action
              },
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (_isScrollAtBottom(notification)) {
              if (!_topicViewModel.isLoading) {
                _topicViewModel.fetchTopicsByUserMore(
                    _auth.currentUser!.uid, 5);
              }
            }
            return false;
          },
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Các topic của bạn:', style: AppStyle.title),
                    if (_topicViewModel.topics.length < 1)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      _listTopics(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _listTopics() {
    return Column(
      children: [
        for (final folder in _folderViewModel.folders)
          SizedBox(
            height: 130,
            child: folder.topicRefs
                    .map((e) => e.id)
                    .contains(_topicViewModel.topic!.id)
                ? _removeFolder(folder)
                : _addFolder(folder),
          ),
        if (_topicViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }

  FolderCard _addFolder(FolderModel folderModel) {
    return FolderCard(
      folder: folderModel,
      word: 'Thêm',
      onContinue: () {
        setState(() {
          _folderViewModel.addTopicToFolder(
              _auth.currentUser!.uid, _topicViewModel.topic!, folderModel);
        });
      },
    );
  }

  FolderCard _removeFolder(FolderModel folderModel) {
    return FolderCard(
      folder: folderModel,
      word: 'Xóa',
      onContinue: () {
        setState(() {
          _folderViewModel.removeTopicFromFolder(
              _auth.currentUser!.uid, _topicViewModel.topic!, folderModel);
        });
      },
    );
  }
}
