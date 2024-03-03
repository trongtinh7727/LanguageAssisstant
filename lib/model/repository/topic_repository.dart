import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/models/user_topic_ref.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';
import 'package:languageassistant/model/repository/user_repository.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/date_time_util.dart';

class TopicRepository extends BaseRepository<TopicModel> {
  TopicRepository()
      : super(
          collectionPath: 'topics',
          fromMap: TopicModel.fromMap,
          toMap: (topic) => topic.toMap(),
        );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TopicModel> createTopicWithWords(
      TopicModel topic, List<WordModel> words) async {
    // Create the topic and get its ID
    String topicId = await create(topic);
    // Using a batch to perform all writes as a single transaction
    WriteBatch batch = _firestore.batch();

    // Add each word to the batch
    for (var word in words) {
      DocumentReference docRef =
          _firestore.collection('topics/$topicId/words').doc(word.id);
      batch.set(docRef, word.toMap());
    }
    // Commit the batch
    await batch.commit();

    topic.id = topicId;
    topic.authorRef = _firestore.collection('users').doc(topic.author);
    await update(topicId, topic);
    final _topicReference = UserTopicRef(
        lastAccess: topic.updateTime,
        topicRef: _firestore.collection("topics").doc(topicId));
    final _userRepository = UserRepository();
    _userRepository.addTopicToUser(topic.author, topicId, _topicReference);
    return topic;
  }

  Future<TopicModel> updateTopicWithWords(TopicModel topic,
      List<WordModel> words, List<WordModel> removedWords) async {
    // Create the topic and get its ID
    await update(topic.id, topic);
    // Using a batch to perform all writes as a single transaction
    WriteBatch batch = _firestore.batch();

    // Add each word to the batch
    final _wordCollection = _firestore.collection('topics/${topic.id}/words');
    for (var word in words) {
      DocumentReference docRef = _wordCollection.doc(word.id);
      batch.set(docRef, word.toMap(), SetOptions(merge: true));
    }
    for (var word in removedWords) {
      DocumentReference docRef = _wordCollection.doc(word.id);
      batch.delete(docRef);
    }
    // Commit the batch
    await batch.commit();

    return topic;
  }

  Future<TopicModel> updateLearningStatus(String userID, TopicModel topic,
      List<WordModel> words, int wordLearned, int updateTime) async {
    await update(topic.id, topic);

    WriteBatch batch = _firestore.batch();
    final _wordCollection = _firestore.collection('topics/${topic.id}/words');
    for (var word in words) {
      DocumentReference docRef = _wordCollection.doc(word.id);
      batch.set(docRef, word.toMap(), SetOptions(merge: true));
    }

    // Commit the batch
    await batch.commit();

    final _topicReference = UserTopicRef(
      lastAccess: updateTime,
      topicRef: _firestore.collection("topics").doc(topic.id),
      wordLearned: wordLearned,
    );
    final _userRepository = UserRepository();
    _userRepository.addTopicToUser(userID, topic.id, _topicReference);
    return topic;
  }

  Future<bool> deleteCollection(Query collection) async {
    QuerySnapshot querySnapshot = await collection.get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      try {
        await documentSnapshot.reference.delete();
      } catch (e) {
        return false;
      }
    }
    return true;
  }

  Future<void> deleteTopic(String topicID) async {
    try {
      bool success1 = await deleteCollection(_firestore
          .collectionGroup("topics")
          .where("topicRef",
              isEqualTo: _firestore.collection("topics").doc(topicID)));
      if (!success1) {
        return;
      }
      bool success2 = await deleteCollection(_firestore
          .collection("topics")
          .doc(topicID)
          .collection("leaderBoard"));
      if (!success2) {
        return;
      }
      bool success3 = await deleteCollection(
          _firestore.collection("topics").doc(topicID).collection("words"));
      if (!success3) {
        return;
      }

      await _firestore.collection("topics").doc(topicID).delete();
    } catch (e) {
      print(e.toString());
    }
  }

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
        final authorSnapshot = await topic.authorRef?.get();
        final author = UserModel.fromMap(
            authorSnapshot!.data() as Map<String, dynamic>, authorSnapshot.id);
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

  Future<Pair<List<TopicModel>, Pair<bool, DocumentSnapshot?>>>
      getUserTopicsOfFolder(
    String userId, {
    DocumentSnapshot? lastDocument,
    required FolderModel folderModel,
    required int pageSize,
  }) async {
    if (folderModel.topicRefs.isEmpty) {
      return Pair([], Pair(false, null));
    }
    try {
      var result = await _firestore
          .collection('users')
          .doc(userId)
          .collection('topics')
          .where(FieldPath.documentId,
              whereIn: folderModel.topicRefs.map((ref) => ref.id))
          .limit(pageSize)
          .get();
      final topics = <TopicModel>[];
      bool hasNextPage = false;

      for (var topicRefDocument in result.docs) {
        final topicRef = topicRefDocument.data();
        final topicSnapshot = await topicRef['topicRef'].get();
        final topic = TopicModel.fromMap(
            topicSnapshot.data() as Map<String, dynamic>, topicSnapshot.id);
        // Fetch author data if necessary, similar to the Kotlin code
        final authorSnapshot = await topic.authorRef?.get();
        final author = UserModel.fromMap(
            authorSnapshot!.data() as Map<String, dynamic>, authorSnapshot.id);
        topic.authorName = author.name;
        topic.authoravatar = author.avatarUrl;
        topic.lastAccess = topicRef['lastAccess'];
        topic.wordLearned = topicRef['wordLearned'];

        topics.add(topic);
      }

      hasNextPage = result.docs.length >= pageSize;
      final newLastDocument = result.docs.isNotEmpty ? result.docs.last : null;
      topics.sort((a, b) => b.lastAccess - a.lastAccess);
      return Pair(topics, Pair(hasNextPage, newLastDocument));
    } catch (e) {
      // Handle errors or return an appropriate error state
      return Pair([], Pair(false, null));
    }
  }

  Future<Pair<List<TopicModel>, Pair<bool, DocumentSnapshot?>>> getNewTopics({
    DocumentSnapshot? lastDocument,
    required int pageSize,
  }) async {
    var query = _firestore
        .collection('topics')
        .orderBy('createTime', descending: true)
        .where('public', isEqualTo: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      final querySnapshot = await query.get();
      final topics = <TopicModel>[];
      bool hasNextPage = false;

      for (var topicSnapshot in querySnapshot.docs) {
        final topic = TopicModel.fromMap(
            topicSnapshot.data() as Map<String, dynamic>, topicSnapshot.id);
        // Fetch author data if necessary, similar to the Kotlin code
        final authorSnapshot = await topic.authorRef!.get();
        final author = UserModel.fromMap(
            authorSnapshot.data() as Map<String, dynamic>, authorSnapshot.id);
        topic.authorName = author.name;
        topic.authoravatar = author.avatarUrl;

        topics.add(topic);
      }

      hasNextPage = querySnapshot.docs.length > 0 &&
          querySnapshot.docs.length >= pageSize;

      final newLastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return Pair(topics, Pair(hasNextPage, newLastDocument));
    } catch (e) {
      // Handle errors or return an appropriate error state
      return Pair([], Pair(false, null));
    }
  }

  Future<Pair<List<TopicModel>, Pair<bool, DocumentSnapshot?>>> getTopTopics({
    DocumentSnapshot? lastDocument,
    required int pageSize,
  }) async {
    var query = _firestore
        .collection('topics')
        .orderBy('viewCount', descending: true)
        .where('public', isEqualTo: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      final querySnapshot = await query.get();
      final topics = <TopicModel>[];
      bool hasNextPage = false;

      for (var topicSnapshot in querySnapshot.docs) {
        final topic = TopicModel.fromMap(
            topicSnapshot.data() as Map<String, dynamic>, topicSnapshot.id);
        // Fetch author data if necessary, similar to the Kotlin code
        final authorSnapshot = await topic.authorRef!.get();
        final author = UserModel.fromMap(
            authorSnapshot.data() as Map<String, dynamic>, authorSnapshot.id);
        topic.authorName = author.name;
        topic.authoravatar = author.avatarUrl;

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

  Future<void> setPublic(String topicID, bool isPublic) async {
    final topicDoc = _firestore.collection("topics").doc(topicID);
    await topicDoc.set({'public': isPublic}, SetOptions(merge: true));
  }

  Future<List<RankItem>> getLeaderBoard(String topicID) async {
    final leaderBoardCollection =
        _firestore.collection("topics").doc(topicID).collection("leaderBoard");

    try {
      final querySnapshot = await leaderBoardCollection
          .orderBy("score", descending: true)
          .orderBy("timeDuration", descending: false)
          .orderBy("submitted", descending: false)
          .limit(10)
          .get();

      List<RankItem> leaderBoardList = [];

      for (var document in querySnapshot.docs) {
        final leaderBoardData = document.data();
        final userRef = leaderBoardData['userRef'] as DocumentReference?;

        if (userRef != null) {
          final userSnapshot = await userRef.get();
          final user = UserModel.fromMap(
              userSnapshot.data() as Map<String, dynamic>, userSnapshot.id);

          final timeDuration = leaderBoardData['timeDuration'] ?? 0;
          final time = DateTimeUtil.formatTimeDuration(timeDuration);
          DateTime date = DateTimeUtil.timestampToDateTime(
              leaderBoardData['submitted'] ?? 0);
          String dateFormated = DateFormat('dd/MM/yyyy').format(date);
          final top = "Top #${leaderBoardList.length + 1}";

          leaderBoardList.add(
            RankItem(
              avatarUrl: user.avatarUrl ?? '',
              name: user.name ?? '',
              time: time,
              date: dateFormated,
              rank: top,
            ),
          );
        }
      }
      return leaderBoardList;
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  Future<TopicModel> getUserTopic(String userId, String topicID) async {
    try {
      final userTopicRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('topics')
          .doc(topicID);

      final userTopicSnapshot = await userTopicRef.get();

      if (userTopicSnapshot.exists) {
        final topicRef = userTopicSnapshot['topicRef'];
        final topicSnapshot = await topicRef.get();
        final authorSnapshot = await topicSnapshot['authorRef'].get();

        final topic = TopicModel.fromMap(
            topicSnapshot.data() as Map<String, dynamic>, topicSnapshot.id);
        final author = UserModel.fromMap(
            authorSnapshot.data() as Map<String, dynamic>, authorSnapshot.id);

        topic.authorName = author.name;
        topic.authoravatar = author.avatarUrl;
        topic.lastAccess = userTopicSnapshot['lastAccess'];
        topic.wordLearned = userTopicSnapshot['wordLearned'];

        return topic;
      } else {
        // Handle the case where the user topic does not exist
        throw Exception('User topic not found');
      }
    } catch (e) {
      // Handle errors or return an appropriate error state
      throw Exception('Failed to fetch user topic: $e');
    }
  }
}
