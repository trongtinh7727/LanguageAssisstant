import 'package:flutter/material.dart';
import 'package:languageassistant/view_model/topic_view_model.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assume your ViewModel is provided by a higher-level provider
    final topicViewModel = Provider.of<TopicViewModel>(context);
    topicViewModel.fetchTopics();

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
                return ListTile(
                  title: Text(topic.title),
                  subtitle:
                      Text('By ${topic.author} - ${topic.wordCount} words'),
                  // Rest of your tile layout
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
