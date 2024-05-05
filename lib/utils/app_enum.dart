import 'package:cloud_firestore/cloud_firestore.dart';

enum WordStatus { ALL, NOT_LEARNED, LEARNED, MASTERED, MARKED }

enum LearningMode { FlashCard, WordType, MultipleChoice }

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

class RankItem {
  final String avatarUrl;
  final String name;
  final String time;
  final String date;
  final String rank;
  final int score;
  final int submitted;
  final int timeDuration;
  DocumentReference? userReference;

  RankItem(
      {required this.avatarUrl,
      required this.name,
      required this.time,
      required this.date,
      required this.rank,
      this.score = 0,
      this.timeDuration = 0,
      this.submitted = 0,
      this.userReference});

  Map<String, dynamic> toMap() {
    return {
      'score': this.score,
      'submitted': this.submitted,
      'timeDuration': this.timeDuration,
      'userRef': this.userReference
    };
  }
}
