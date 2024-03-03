import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/base_repository.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_toast.dart';

class FolderRepository extends BaseRepository<FolderModel> {
  FolderRepository()
      : super(
          collectionPath: 'folders',
          fromMap: FolderModel.fromMap,
          toMap: (folder) => folder.toMap(),
        );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Pair<List<FolderModel>, Pair<bool, DocumentSnapshot?>>> getUserFolders(
    String userId, {
    DocumentSnapshot? lastDocument,
    required int pageSize,
  }) async {
    var query = _firestore
        .collection('users')
        .doc(userId)
        .collection('folders')
        .orderBy('updateTime', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    try {
      final querySnapshot = await query.get();
      final folders = <FolderModel>[];
      bool hasNextPage = false;

      for (var folderRef in querySnapshot.docs) {
        final folder = FolderModel.fromMap(
            folderRef.data() as Map<String, dynamic>, folderRef.id);
        folders.add(folder);
      }

      hasNextPage = querySnapshot.docs.length >= pageSize;
      final newLastDocument =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return Pair(folders, Pair(hasNextPage, newLastDocument));
    } catch (e) {
      // Handle errors or return an appropriate error state
      return Pair([], Pair(false, null));
    }
  }

  Future<void> deleteFolder(String userId, String folderId) async {
    try {
      final DocumentReference folderDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId); // Lấy tham chiếu đến tài liệu cần xóa

      await folderDocRef.delete(); // Xóa tài liệu

      successToast('Xóa thành công');
    } catch (e) {
      errorToast('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  Future<void> updateFolder(String userId, FolderModel folderModel) async {
    try {
      final CollectionReference folderCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders');

      final folderDocRef = folderCollection.doc(folderModel.id);

      await folderDocRef.set(folderModel.toMap(), SetOptions(merge: true));

      successToast('Cập nhật thành công');
    } catch (e) {
      errorToast('Có lỗi xảy ra: ${e.toString()}');
    }
  }

  Future<void> createFolder(String userId, FolderModel folderModel) async {
    try {
      final CollectionReference folderCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('folders');
      final newFolderDocRef = folderCollection.doc();
      folderModel.id = newFolderDocRef.id;

      await newFolderDocRef.set(folderModel.toMap());
      successToast('Tạo thành công');
    } catch (e) {
      errorToast('Có lỗi xảy ra: ${e.toString()}');
    }
  }
}
