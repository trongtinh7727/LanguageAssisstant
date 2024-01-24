import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';

class TopicCard extends StatelessWidget {
  final String title;
  final int wordCount;
  final int totalWords;
  final String authorName;
  final String? authorAvatar;
  final String timeAgo;
  final VoidCallback onContinue;

  const TopicCard({
    Key? key,
    required this.title,
    required this.wordCount,
    required this.totalWords,
    required this.authorName,
    this.authorAvatar,
    required this.timeAgo,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$wordCount/$totalWords words',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: wordCount / totalWords,
              backgroundColor: Colors.blue[100],
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(authorAvatar ??
                          'https://firebasestorage.googleapis.com/v0/b/language-assistant-7727.appspot.com/o/Users%2FAvatars%2Favatar_default.png?alt=media&token=490b3731-c6a2-4d1b-a75a-4902372c307b'),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Log the error, show a dialog, or use a fallback image
                        print('Error loading background image: $exception');
                      },
                      child: authorAvatar == null
                          ? Icon(Icons
                              .person) // Fallback icon in case the URL is null
                          : null,
                    ),
                    SizedBox(width: 8),
                    Text(
                      authorName,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onContinue,
                child: Text('CONTINUE'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: TopicCard(
            title: 'Topic: Expressions/Questions',
            wordCount: 2,
            totalWords: 10,
            authorName: 'Ariana HeHe',
            timeAgo: '30 phút trước',
            onContinue: () {
              // Handle continue action here
              print('Continue tapped');
            },
          ),
        ),
      ),
    ),
  );
}
