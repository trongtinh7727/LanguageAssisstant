import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';

class TopicViewModel extends ChangeNotifier {
  List<TopicModel> _topics = [];
  final TopicRepository _topicRepository = new TopicRepository();

  List<TopicModel> get topics => _topics;

  void fetchTopics() async {
    _topics = await _topicRepository.readAll();
    notifyListeners();
  }
}
