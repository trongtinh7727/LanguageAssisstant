import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/model/repository/word_repository.dart';
import 'package:languageassistant/utils/app_enum.dart';

class TopicViewModel extends ChangeNotifier {
  List<TopicModel> _topics = [];
  List<WordModel> _words = [];
  List<RankItem> _ranks = [];

  final TopicRepository _topicRepository = TopicRepository();
  final WordRepository _wordRepository = WordRepository();
  bool _isLoading = false; // Thêm biến này

  List<TopicModel> get topics => _topics;
  List<RankItem> get ranks => _ranks;
  List<WordModel> get words => _words; // Getter for words

  bool _hasNextPage = false;
  DocumentSnapshot? _lastDocument;

  bool get hasNextPage => _hasNextPage;
  DocumentSnapshot? get lastDocument => _lastDocument;
  bool get isLoading => _isLoading; // Thêm getter này

  void fetchTopics() async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      _topics = await _topicRepository.readAll();
      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  void fetchLeaderBoard(String topicID) async {
    _isLoading = true; //
    notifyListeners();
    _ranks = await _topicRepository.getLeaderBoard(topicID);
    _isLoading = false;
    notifyListeners();
  }

  void fetchWordsByStatus(
      String userId, String topicId, WordStatus status) async {
    _isLoading = true;
    notifyListeners();

    _wordRepository.getAllByStatus(userId, topicId, status,
        (List<WordModel> words) {
      // This is the onComplete callback
      _words = words; // Update the _words list with the fetched words
      _isLoading = false;
      notifyListeners();
    });
  }

  void fetchTopicsByUser(String userId, int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getUserTopics(userId,
          lastDocument: null, pageSize: pageSize);
      _topics = result.first;
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

  Future<void> markWord(
      String topicId, String wordId, String userId, bool newStatus) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result =
          await _wordRepository.mark(topicId, wordId, userId, newStatus);
      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  Future<void> fetchTopicsByUserMore(String userId, int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getUserTopics(userId,
          lastDocument: _lastDocument, pageSize: pageSize);
      _topics.addAll(result.first);
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

  Future<TopicModel> createTopic(
      TopicModel topic, List<WordModel> words) async {
    _isLoading = true;
    notifyListeners();

    try {
      final addedTopic =
          await _topicRepository.createTopicWithWords(topic, words);
      _isLoading = false;
      notifyListeners();
      return addedTopic;
    } catch (e) {
      _isLoading = false;
      print('Error creating topic: $e');
      notifyListeners();
      return topic;
    }
  }

  Future<void> setPublic(String topicID, bool isPublic) async {
    _isLoading = true;
    notifyListeners();
    _topicRepository.setPublic(topicID, isPublic).whenComplete(() {
      _isLoading = false;
      notifyListeners();
    });
  }

  void fillter(String filter, String userID, String topicID) {
    switch (filter) {
      case "Tất cả":
        fetchWordsByStatus(
          userID,
          topicID,
          WordStatus.ALL,
        );
        break;
      case "Đã học":
        fetchWordsByStatus(
          userID,
          topicID,
          WordStatus.LEARNED,
        );
        break;
      case "Chưa học":
        fetchWordsByStatus(
          userID,
          topicID,
          WordStatus.NOT_LEARNED,
        );
        break;
      case "Đã thành thạo":
        fetchWordsByStatus(
          userID,
          topicID,
          WordStatus.MASTERED,
        );
        break;
    }
  }
}
