import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';

class LibTopicWidget extends StatelessWidget {
  const LibTopicWidget({
    super.key,
    required ScrollController scrollController,
    required this.topicViewModel,
    required FirebaseAuth auth,
  })  : _scrollController = scrollController,
        _auth = auth;

  final ScrollController _scrollController;
  final TopicViewModel topicViewModel;
  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    if (topicViewModel.topics.length < 1) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: topicViewModel.topics.length,
      itemBuilder: (context, index) {
        final topic = topicViewModel.topics[index];
        return TopicCard(
          topic: topic,
          onContinue: () {
            topicViewModel.setTopic(topic);
            topicViewModel.fetchTopic(_auth.currentUser!.uid, topic.id);
            topicViewModel.fetchWordsByStatus(
                _auth.currentUser!.uid, topic.id, WordStatus.ALL);
            topicViewModel.fetchLeaderBoard(topic.id);
            Navigator.pushNamed(
              context,
              RouteName.topicDetailScreen,
            );
          },
        );
      },
    );
  }
}
