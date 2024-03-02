import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageassistant/utils/app_enum.dart';

class WordRepository extends BaseRepository<WordModel> {
  final String collectionPath;
  WordRepository({this.collectionPath = ""})
      : super(
          collectionPath: collectionPath,
          fromMap: WordModel.fromMap,
          toMap: (word) => word.toMap(),
        );

  void getAllByStatus(
    String userID,
    String topicId,
    WordStatus status,
    Function(List<WordModel>) onComplete,
  ) {
    CollectionReference wordCollection = FirebaseFirestore.instance
        .collection("topics")
        .doc(topicId)
        .collection("words");

    Query query;
    if (status == WordStatus.ALL || status == WordStatus.MARKED) {
      query = wordCollection;
    } else if (status == WordStatus.NOT_LEARNED) {
      query = wordCollection;
    } else {
      query =
          wordCollection.where("statusByUser.$userID", isEqualTo: status.name);
    }

    query.snapshots().listen((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        onComplete([]);
        return;
      }

      List<WordModel> words = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        WordModel word =
            WordModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        if (word.bookmarkByUser[userID] ?? false) {
          word.isMarked = true;
        }

        if (status == WordStatus.NOT_LEARNED) {
          if (word.statusByUser[userID] == null) {
            words.add(word);
          }
        } else if (status == WordStatus.MARKED) {
          if (word.isMarked) {
            words.add(word);
          }
        } else {
          words.add(word);
        }
      }
      onComplete(words);
    }, onError: (error) {
      // Handle any errors appropriately
      onComplete([]);
    });
  }

  Future<void> mark(
      String topicId, String wordId, String userId, bool newStatus) async {
    final wordCollection = FirebaseFirestore.instance
        .collection('topics')
        .doc(topicId)
        .collection('words')
        .doc(wordId);

    try {
      final documentSnapshot = await wordCollection.get();

      if (documentSnapshot.exists) {
        final wordData = documentSnapshot.data() as Map<String, dynamic>;
        final word = WordModel.fromMap(wordData, documentSnapshot.id);

        final updatedStatusByUser = Map<String, bool>.from(word.bookmarkByUser);
        updatedStatusByUser[userId] = newStatus;

        final currentTime = DateTime.now().millisecondsSinceEpoch;

        word.updateTime = currentTime;
        word.bookmarkByUser = updatedStatusByUser;

        await wordCollection.update({
          'bookmarkByUser': updatedStatusByUser,
          'updateTime': currentTime,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
