import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/model/repository/word_repository.dart';

class HomeViewModel extends ChangeNotifier {
  List<TopicModel> _topics = [];
  List<TopicModel> _topicLearderboard = [];
  List<TopicModel> _recentTopics = [];
  final TopicRepository _topicRepository = TopicRepository();

  bool _isLoading = false; // Thêm biến này

  List<TopicModel> get topics => _topics;
  List<TopicModel> get topicLeaderboard => _topicLearderboard;
  List<TopicModel> get recentTopics => _recentTopics; // Getter for words

  bool _hasNextPage = false;
  DocumentSnapshot? _lastDocument;

  bool get hasNextPage => _hasNextPage;
  DocumentSnapshot? get lastDocument => _lastDocument;
  bool get isLoading => _isLoading; // Thêm getter này

  void fetchNewTopics(int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getNewTopics(
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

  void fetchTopTopics(int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getTopTopics(
          lastDocument: null, pageSize: pageSize);
      _topicLearderboard = result.first;
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

  void fetchRecentTopics(String userId, int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();

    try {
      final result = await _topicRepository.getUserTopics(userId,
          lastDocument: null, pageSize: pageSize);
      _recentTopics = result.first;

      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  Future<void> fetchNewTopicMore(int pageSize) async {
    _isLoading = true; // Cập nhật trạng thái tải
    notifyListeners();
    try {
      if (_hasNextPage) {
        final result = await _topicRepository.getNewTopics(
            lastDocument: _lastDocument, pageSize: pageSize);
        _topics.addAll(result.first);
        _hasNextPage = result.second.first;
        _lastDocument = result.second.second;
      }
      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }
}
