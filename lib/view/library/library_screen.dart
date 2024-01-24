import 'package:flutter/material.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:languageassistant/widget/personal_topic_card.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    // We use `WidgetsBinding.instance.addPostFrameCallback` to make sure the
    // context is fully built before we try to access the Provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final topicViewModel =
            Provider.of<TopicViewModel>(context, listen: false);
        topicViewModel.fetchTopicsByUser('jQBsoZuLugWdlbCPWEDLShzw6tU2', 5);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topicViewModel = Provider.of<TopicViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thư Viện'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Handle add button
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Your search bar and tabs
          Expanded(
            child: ListView.builder(
              itemCount: topicViewModel.topics.length,
              itemBuilder: (context, index) {
                final topic = topicViewModel.topics[index];
                return TopicCard(
                  title: topic.title ?? 'No Title',
                  wordCount: topic.wordLearned,
                  authorAvatar: topic.authoravatar,
                  totalWords: topic.wordCount, // Adjust this based on your data
                  authorName: topic.authorName ?? 'Unknown',
                  timeAgo:
                      '30 phút trước', // Replace with dynamic time based on topic.createTime
                  onContinue: () {
                    // Handle continue action here
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
