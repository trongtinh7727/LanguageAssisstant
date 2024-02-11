import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_color.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/custom_button.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late PageController pageController;
  late ScrollController _scrollController;
  late TopicViewModel topicViewModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int current = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    pageController = PageController();
    topicViewModel = Provider.of<TopicViewModel>(context, listen: false);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Call load more method from your viewmodel
      if (topicViewModel.hasNextPage) {
        topicViewModel.fetchTopicsByUserMore(
          _auth.currentUser!.uid,
          5,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
    List<String> items = ["Topic", "Folder"];

    return Container(
      alignment: Alignment.center,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items.map((item) {
          int index = items.indexOf(item);
          return GestureDetector(
            onTap: () {
              setState(() {
                current = index;
              });
              pageController.animateToPage(
                current,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: current == index ? primaryColor : tabUnselectedColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.blue, width: 2.5),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: current == index ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topicViewModel = Provider.of<TopicViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thư Viện'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle add button
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: _buildCustomTabBar(),
        ),
      ),
      body: Stack(children: <Widget>[
        PageView.builder(
          itemCount: 2, // Number of pages
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              current = index;
            });
          },
          itemBuilder: (context, index) {
            // Your Tab Contents
            if (index == 0) {
              // First tab content: Topic
              return ListView.builder(
                controller: _scrollController,
                itemCount: topicViewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = topicViewModel.topics[index];
                  return TopicCard(
                    topic: topic,
                    onContinue: () {
                      // Handle continue action here
                      topicViewModel.fetchWordsByStatus(
                          _auth.currentUser!.uid, topic.id, WordStatus.ALL);
                      topicViewModel.fetchLeaderBoard(topic.id);
                      Navigator.pushNamed(context, RouteName.topicDetailScreen,
                          arguments: topic);
                    },
                  );
                },
              );
            } else {
              // Second tab content: Folder
              return Center(
                child: Text('Folder content goes here'),
              );
            }
          },
        ),
        if (topicViewModel.isLoading)
          Container(
            color: Colors.black45,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}
