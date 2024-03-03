import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/folder_view_model.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:languageassistant/widget/topic_leaderboard_item.dart';
import 'package:provider/provider.dart';

class FolderDetailScreen extends StatefulWidget {
  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  late FolderViewModel _folderViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _folderViewModel = Provider.of<FolderViewModel>(context, listen: false);
  }

  bool _isScrollAtBottom(ScrollNotification notification) {
    return notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final _folderViewModel = Provider.of<FolderViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('IIEX'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement your search action
              },
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // if (_isScrollAtBottom(notification)) {
            //   if (!_folderViewModel.isLoading) {
            //     _folderViewModel.fetchNewTopicMore(5);
            //   }
            // }
            return false;
          },
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_folderViewModel.folder!.title!,
                        style: const TextStyle(
                          color: AppStyle.activeText,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.18,
                        )),
                    Text('${_folderViewModel.folder!.topicCount} topics',
                        style: const TextStyle(
                          color: AppStyle.activeText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.18,
                        )),
                    if (_folderViewModel.topics.length < 1)
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
    final _folderViewModel = Provider.of<FolderViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);

    return Column(
      children: [
        for (final topic in _folderViewModel.topics)
          SizedBox(
            // width: 320,
            height: 130,
            child: TopicCard(
              topic: topic,
              onContinue: () {
                // Handle continue action here
                _topicViewModel.setTopic(topic);
                _topicViewModel.fetchTopic(_auth.currentUser!.uid, topic.id);

                _topicViewModel.fetchWordsByStatus(
                    _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                _topicViewModel.fetchLeaderBoard(topic.id);
                Navigator.pushNamed(
                  context,
                  RouteName.topicDetailScreen,
                );
              },
            ),
          ),
        if (_folderViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
