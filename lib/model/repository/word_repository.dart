import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageassistant/utils/app_enum.dart';

class WordRepository extends BaseRepository<WordModel> {
  WordRepository()
      : super(
          collectionPath: 'words',
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
    if (status == WordStatus.ALL) {
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
}
