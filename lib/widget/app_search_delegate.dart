import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class AppSearchDelegate extends SearchDelegate {
  final TopicRepository _topicRepository = TopicRepository();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<TopicModel>>(
      future: _topicRepository.searchTopicsByTitle(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final List<TopicModel> topics = snapshot.data ?? [];
        final _topicViewModel = Provider.of<TopicViewModel>(context);
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final topic = topics[index];
            return SizedBox(
              height: 130,
              child: TopicCard(
                topic: topic,
                onContinue: () {
                  _topicViewModel.setTopic(topic);
                  _topicViewModel.fetchTopic(
                      FirebaseAuth.instance.currentUser!.uid, topic.id);
                  _topicViewModel.fetchWordsByStatus(
                      FirebaseAuth.instance.currentUser!.uid,
                      topic.id,
                      WordStatus.ALL);
                  _topicViewModel.fetchLeaderBoard(topic.id);
                  Navigator.pushNamed(
                    context,
                    RouteName.topicDetailScreen,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Không cần thực hiện phương thức này trong trường hợp này.
    return Container();
  }
}
