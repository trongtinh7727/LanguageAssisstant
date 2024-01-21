import 'package:cloud_firestore/cloud_firestore.dart';

class BaseRepository<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath;
  final T Function(Map<String, dynamic>, String) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  BaseRepository({
    required this.collectionPath,
    required this.fromMap,
    required this.toMap,
  });

  Future<String> create(T item) async {
    DocumentReference docRef =
        await _firestore.collection(collectionPath).add(toMap(item));
    return docRef.id;
  }

  Future<T?> read(String id) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection(collectionPath).doc(id).get();
    if (docSnapshot.exists) {
      return fromMap(
          docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
    }
    return null;
  }

  Future<void> update(String id, T item) async {
    await _firestore.collection(collectionPath).doc(id).update(toMap(item));
  }

  Future<void> delete(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Stream<List<T>> streamData() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<List<T>> readAll() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).get();
    return querySnapshot.docs
        .map((doc) => fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
