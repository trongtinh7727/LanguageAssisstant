import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:languageassistant/routes/name_routes.dart';

import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_style.dart';
import 'package:languageassistant/view_model/home_view_model.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:languageassistant/widget/topic_leaderboard_item.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _homeViewModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  bool _isScrollAtBottom(ScrollNotification notification) {
    return notification.metrics.pixels == notification.metrics.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final yellow_1 = HexColor('#FDFF9b');
    final yellow_2 = HexColor('#FFB800');
    final blue_1 = HexColor('#9BF9FF');
    final blue_2 = HexColor('#409CDF');
    final violet_1 = HexColor('#EBC0FF');
    final violet_2 = HexColor('#D467FA');
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
            if (_isScrollAtBottom(notification)) {
              if (!_homeViewModel.isLoading) {
                _homeViewModel.fetchNewTopicMore(5);
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
                    Text('Tiếp tục bài học trước', style: AppStyle.title),
                    if (_homeViewModel.recentTopics.length < 1)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      _recentTopics(),
                    Text('Hôm nay làm gì?', style: AppStyle.title),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _customButton([yellow_1, yellow_2], () => {},
                              "Luyện tập bài học hằng ngày"),
                          SizedBox(
                            height: 8,
                          ),
                          _customButton(
                              [blue_1, blue_2], () => {}, "Học theo chủ đề"),
                          SizedBox(
                            height: 8,
                          ),
                          _customButton(
                              [violet_1, violet_2], () => {}, "Khám phá thêm"),
                        ],
                      ),
                    ),
                    Text('Gợi ý cho bạn', style: AppStyle.title),
                    if (_homeViewModel.topicLeaderboard.length < 1)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      _topTopics(),
                    Text('Cộng đồng', style: AppStyle.title),
                    if (_homeViewModel.topics.length < 1)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      _newTopics(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  ElevatedButton _customButton(
      List<HexColor> colors, VoidCallback _onClick, String _title) {
    return ElevatedButton(
      onPressed: _onClick,
      style: ElevatedButton.styleFrom(
        primary: AppStyle.tabUnselectedColor, // Background color
        onPrimary: Colors.black, // Text color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side:
            BorderSide(color: Colors.blue, width: 1), // Border color and width
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize:
            MainAxisSize.max, // Use min to make the button wrap its content
        children: <Widget>[
          Text(
            _title,
            style: AppStyle.title,
          ), // The label text
          SizedBox(width: 8), // Space between text and icon
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              // color: Colors.yellow, // Background color of the icon container
              shape: BoxShape.circle, // Circular shape
            ),
            padding:
                EdgeInsets.all(8), // Padding inside the container for the icon
            child: Icon(
              Icons.arrow_forward_ios, // Arrow icon
              size: 16, // Icon size
              color: HexColor('#004AB9'), // Icon color
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentTopics() {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return SizedBox(
      height: 136, // Chiều cao cố định cho ListView.builder
      width: MediaQuery.of(context).size.width - 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _homeViewModel.recentTopics.length,
        itemBuilder: (context, index) {
          final topic = _homeViewModel.recentTopics[index];
          return SizedBox(
            width: 320,
            height: 100,
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
          );
        },
      ),
    );
  }

  Widget _newTopics() {
    final _homeViewModel = Provider.of<HomeViewModel>(context);
    final _topicViewModel = Provider.of<TopicViewModel>(context);
    return Column(
      children: [
        for (final topic in _homeViewModel.topics)
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
        if (_homeViewModel.isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
      ],
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
          );
        },
      ),
    );
  }
}
