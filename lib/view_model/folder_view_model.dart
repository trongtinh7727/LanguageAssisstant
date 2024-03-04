import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:languageassistant/model/models/folder_model.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/folder_repository.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';

class FolderViewModel extends ChangeNotifier {
  List<FolderModel> _folders = [];
  List<TopicModel> _topics = [];
  FolderModel? _folder;

  final TopicRepository _topicRepository = TopicRepository();
  final FolderRepository _folderRepository = FolderRepository();
  bool _isLoading = false; // Thêm biến này
  List<FolderModel> get folders => _folders; // Getter for words
  List<TopicModel> get topics => _topics; // Getter for words
  bool _hasNextPage = false;
  DocumentSnapshot? _lastDocument;
  FolderModel? get folder => _folder;

  bool get hasNextPage => _hasNextPage;
  DocumentSnapshot? get lastDocument => _lastDocument;
  bool get isLoading => _isLoading; // Thêm getter này

  void setFolder(FolderModel model) {
    _folder = model;
    notifyListeners();
  }

  Future<void> fetchFoldersByUser(String userId, int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _folderRepository.getUserFolders(userId,
          lastDocument: null, pageSize: pageSize);
      _folders = result.first;
      _hasNextPage = result.second.first;
      _lastDocument = result.second.second;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  Future<void> createFolder(String userId, FolderModel folderModel) async {
    await _folderRepository.createFolder(userId, folderModel);
    _folders.insert(0, folderModel);
    notifyListeners();
  }

  Future<void> updateFolder(String userId, FolderModel folderModel) async {
    await _folderRepository.updateFolder(userId, folderModel);
    notifyListeners();
  }

  Future<void> addTopicToFolder(
      String userID, TopicModel topicModel, FolderModel folderModel) async {
    folderModel.topicRefs.add(
        FirebaseFirestore.instance.collection('topics').doc(topicModel.id));
    folderModel.topicCount = folderModel.topicRefs.length;
    _topics.add(topicModel);
    notifyListeners();
    await _folderRepository.updateFolder(userID, folderModel);
    notifyListeners();
  }

  Future<void> removeTopicFromFolder(
      String userID, TopicModel topicModel, FolderModel folderModel) async {
    folderModel.topicRefs.removeWhere(
      (element) => element.id == topicModel.id,
    );
    folderModel.topicCount = folderModel.topicRefs.length;
    _topics.removeWhere(
      (element) => element.id == topicModel.id,
    );
    notifyListeners();
    await _folderRepository.updateFolder(userID, folderModel);
    notifyListeners();
  }

  Future<void> deleteFolder(String userID, String folderID) async {
    notifyListeners();
    await _folderRepository.deleteFolder(userID, folderID);
    _folders.remove(_folder);
    notifyListeners();
  }

  Future<void> fetchUserTopicsByFolder(
      String userId, FolderModel folder, int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getUserTopicsOfFolder(userId,
          folderModel: folder, lastDocument: null, pageSize: pageSize);
      _topics = result.first;
      _hasNextPage = result.second.first;
      _lastDocument = result.second.second;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }
}
