import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  String id;
  String author;
  String? authorName;
  String? authoravatar;
  String title;
  String? description;
  int wordLearned;
  int lastAccess;
  int wordCount;
  int viewCount;
  bool public;
  DocumentReference? authorRef;
  int createTime;
  int updateTime;

  TopicModel({
    required this.id,
    required this.title,
    this.description,
    this.wordLearned = -1,
    this.lastAccess = 0,
    this.wordCount = 0,
    this.viewCount = 0,
    this.public = false,
    required this.author,
    this.authorRef,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'wordCount': wordCount,
      'viewCount': viewCount,
      'public': public,
      'author': author,
      'authorRef': authorRef,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  static TopicModel fromMap(Map<String, dynamic> map, String id) {
    return TopicModel(
      id: id,
      title: map['title'],
      description: map['description'],
      wordCount: map['wordCount'],
      viewCount: map['viewCount'],
      public: map['public'],
      author: map['author'],
      authorRef: map['authorRef'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
    );
  }
}
