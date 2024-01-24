import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';

class TopicRepository extends BaseRepository<TopicModel> {
  TopicRepository()
      : super(
          collectionPath: 'topics',
          fromMap: TopicModel.fromMap,
          toMap: (topic) => topic.toMap(),
        );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Pair<List<TopicModel>, Pair<bool, DocumentSnapshot?>>> getUserTopics(
    String userId, {
    DocumentSnapshot? lastDocument,
    required int pageSize,
  }) async {
    var query = _firestore
        .collection('users')
        .doc(userId)
        .collection('topics')
        .orderBy('lastAccess', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      final querySnapshot = await query.get();
      final topics = <TopicModel>[];
      bool hasNextPage = false;

      for (var topicRefDocument in querySnapshot.docs) {
        final topicRef = topicRefDocument.data();
        final topicSnapshot = await topicRef['topicRef'].get();
        final topic = TopicModel.fromMap(
            topicSnapshot.data() as Map<String, dynamic>, topicSnapshot.id);
        // Fetch author data if necessary, similar to the Kotlin code
        final authorSnapshot = await topic.authorRef.get();
        final author = UserModel.fromMap(
            authorSnapshot.data() as Map<String, dynamic>, authorSnapshot.id);
        topic.authorName = author.name;
        topic.authoravatar = author.avatarUrl;
        topic.lastAccess = topicRef['lastAccess'];
        topic.wordLearned = topicRef['wordLearned'];

        topics.add(topic);
      }

      hasNextPage = querySnapshot.docs.length >= pageSize;
      final newLastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return Pair(topics, Pair(hasNextPage, newLastDocument));
    } catch (e) {
      // Handle errors or return an appropriate error state
      return Pair([], Pair(false, null));
    }
  }
}

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}
