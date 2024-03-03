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

  RankItem({
    required this.avatarUrl,
    required this.name,
    required this.time,
    required this.date,
    required this.rank,
  });

  // Add a fromMap constructor if needed
}
