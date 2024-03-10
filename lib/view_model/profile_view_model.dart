import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:languageassistant/model/models/user_model.dart';
import 'package:languageassistant/model/repository/user_repository.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  List<TopicModel> _personalTopics = [];
  UserModel? _userModel;
  final TopicRepository _topicRepository = TopicRepository();
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = false; // Thêm biến này

  List<TopicModel> get personalTopics => _personalTopics;
  UserModel? get userModel => _userModel;

  bool _hasNextPage = false;
  DocumentSnapshot? _lastDocument;

  bool get hasNextPage => _hasNextPage;
  DocumentSnapshot? get lastDocument => _lastDocument;
  bool get isLoading => _isLoading;

  void fetchUser(String userID) async {
    _userModel = await _userRepository.read(userID);
    notifyListeners();
  }

  void fetchPersonalTopics(
      {int pageSize = 5,
      required String authorID,
      bool isPublic = true}) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getTopicsByAuthor(
          authorID: authorID,
          isPublic: isPublic,
          lastDocument: null,
          pageSize: pageSize);
      _personalTopics = result.first;
      _hasNextPage = result.second.first;
      _lastDocument = result.second.second;

      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  Future<void> fetchPersonalTopicsMore(
      {int pageSize = 5,
      required String authorID,
      bool isPublic = false}) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();
    try {
      if (_hasNextPage) {
        final result = await _topicRepository.getTopicsByAuthor(
            authorID: authorID,
            isPublic: isPublic,
            lastDocument: _lastDocument,
            pageSize: pageSize);
        _personalTopics.addAll(result.first);
        _hasNextPage = result.second.first;
        _lastDocument = result.second.second;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  void uploadAvatar(File imageFile, String userID) async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child("Users/Avatars/$userID");
    UploadTask uploadTask = storageRef.putFile(imageFile);

    try {
      await uploadTask.whenComplete(() async {
        String downloadUrl = await storageRef.getDownloadURL();
        _userRepository.updateAvatar(userID, downloadUrl);
      });
      successToast('Đã upload thành công!');
    } catch (error) {
      errorToast('Có lỗi xảy ra!');
      print("Error uploading avatar: $error");
    }
  }
}
