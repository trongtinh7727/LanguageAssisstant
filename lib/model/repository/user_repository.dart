import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/models/user_topic_ref.dart';
import 'package:languageassistant/model/repository/base_repository.dart';
import 'package:languageassistant/utils/app_toast.dart';

class UserRepository extends BaseRepository<UserModel> {
  UserRepository()
      : super(
          collectionPath: 'users',
          fromMap: UserModel.fromMap,
          toMap: (user) => user.toMap(),
        );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addTopicToUser(
      String userId, String topicId, UserTopicRef newTopicRef) async {
    DocumentReference userDocument = _firestore.collection("users").doc(userId);
    CollectionReference userTopicCollection = userDocument.collection("topics");
    await userTopicCollection.doc(topicId).set(newTopicRef.toMap());
  }

  Future<void> addUser(String userId, UserModel userModel) async {
    await _firestore.collection("users").doc(userId).set(userModel.toMap());
  }

  void updateAvatar(String userID, String downloadUrl) async {
    await _firestore.collection("users").doc(userID).update({
      'avatarUrl': downloadUrl,
    });
  }
}
