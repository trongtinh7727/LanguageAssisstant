import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class AddTopicsToFolder extends StatefulWidget {
  @override
  _AddTopicsToFolderState createState() => _AddTopicsToFolderState();
}

class _AddTopicsToFolderState extends State<AddTopicsToFolder> {
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
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return Column(
      children: [
        for (final topic in _topicViewModel.topics)
          SizedBox(
            // width: 320,
            height: 130,
            child: _folderViewModel.topics.map((e) => e.id).contains(topic.id)
                ? _removeTopicCard(topic)
                : _addTopicCard(topic),
          ),
        if (_topicViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }

  TopicCard _addTopicCard(TopicModel topic) {
    return TopicCard(
      topic: topic,
      word: 'Thêm',
      onContinue: () {
        setState(() {
          _folderViewModel.addTopicToFolder(
              _auth.currentUser!.uid, topic, _folderViewModel.folder!);
        });
      },
    );
  }

  TopicCard _removeTopicCard(TopicModel topic) {
    return TopicCard(
      topic: topic,
      word: 'Xóa',
      onContinue: () {
        setState(() {
          _folderViewModel.removeTopicFromFolder(
              _auth.currentUser!.uid, topic, _folderViewModel.folder!);
        });
      },
    );
  }
}
