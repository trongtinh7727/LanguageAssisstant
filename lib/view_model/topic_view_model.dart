import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';

class TopicViewModel extends ChangeNotifier {
  List<TopicModel> _topics = [];
  final TopicRepository _topicRepository = TopicRepository();

  List<TopicModel> get topics => _topics;
  bool _hasNextPage = false;
  DocumentSnapshot? _lastDocument;

  bool get hasNextPage => _hasNextPage;
  DocumentSnapshot? get lastDocument => _lastDocument;

  void fetchTopics() async {
    _topics = await _topicRepository.readAll();
    notifyListeners();
  }

  void fetchTopicsByUser(String userId, int pageSize) async {
    try {
      final result = await _topicRepository.getUserTopics(userId,
          lastDocument: _lastDocument, pageSize: pageSize);
      _topics = result.first;
      _hasNextPage = result.second.first;
      _lastDocument = result.second.second;

      notifyListeners();
    } catch (e) {
      print('Error fetching topics: $e');
    }
  }
}
