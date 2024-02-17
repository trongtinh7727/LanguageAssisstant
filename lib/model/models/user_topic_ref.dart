import 'package:cloud_firestore/cloud_firestore.dart';

class UserTopicRef {
  int lastAccess;
  int wordLearned;
  DocumentReference? topicRef;

  UserTopicRef({
    this.lastAccess = 0,
    this.wordLearned = 0,
    this.topicRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'lastAccess': lastAccess,
      'wordLearned': wordLearned,
      'topicRef': topicRef,
    };
  }

  static UserTopicRef fromMap(Map<String, dynamic> map, String id) {
    return UserTopicRef(
      lastAccess: map['lastAccess'],
      wordLearned: map['wordLearned'],
      topicRef: map['topicRef'],
    );
  }
}
