import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:languageassistant/widget/topic_leaderboard_item.dart';
import 'package:provider/provider.dart';

class DiscoveryScreen extends StatefulWidget {
  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  late HomeViewModel _homeViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final _homeViewModel = Provider.of<HomeViewModel>(context);

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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TOP 10', style: AppStyle.title),
                _topTopics(),
                Text('Bài viết mới', style: AppStyle.title),
                _newTopics(),
                if (_homeViewModel.isLoading)
                  Text('Đang load', style: AppStyle.title),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newTopics() {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return SizedBox(
      height: 500, // Chiều cao cố định cho ListView.builder
      width: MediaQuery.of(context).size.width - 20,
      child: ListView.builder(
        // scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _homeViewModel.topics.length,
        itemBuilder: (context, index) {
          final topic = _homeViewModel.topics[index];
          return SizedBox(
            width: 320,
            height: 125,
            child: TopicCard(
              topic: topic,
              onContinue: () {
                // Handle continue action here
                _topicViewModel.fetchWordsByStatus(
                    _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                _topicViewModel.fetchLeaderBoard(topic.id);
                Navigator.pushNamed(context, RouteName.topicDetailScreen,
                    arguments: topic);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _topTopics() {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return SizedBox(
      height: 200, // Chiều cao cố định cho ListView.builder
      width: MediaQuery.of(context).size.width - 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _homeViewModel.topicLeaderboard.length,
        itemBuilder: (context, index) {
          final topic = _homeViewModel.topicLeaderboard[index];
          final top = index + 1;
          final imagePath = "assets/images/top$top.png";
          return SizedBox(
            width: 140,
            height: 200,
            child: TopicLeaderBoardItem(
              imagePath: imagePath,
              topic: topic,
              onContinue: () {
                // Handle continue action here
                _topicViewModel.fetchWordsByStatus(
                    _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                _topicViewModel.fetchLeaderBoard(topic.id);
                Navigator.pushNamed(context, RouteName.topicDetailScreen,
                    arguments: topic);
              },
            ),
          );
        },
      ),
    );
  }
}
