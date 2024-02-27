import 'dart:math';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/model/repository/word_repository.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_tts.dart';

class LearningViewModel extends ChangeNotifier {
  late TopicModel _topic;
  List<WordModel> _words = [];
  List<WordModel> _learnedWords = [];
  List<WordModel> _masteredWords = [];
  int _currentIndex = 0;
  // WordModel _currentWord = _words[0];
  String _currentFillter = "Tất cả";

  final TopicRepository _topicRepository = TopicRepository();
  final WordRepository _wordRepository = WordRepository();
  final Random _random = Random();
  bool _isLoading = false;
  bool _autoPlayVoice = false;

  TopicModel get topic => _topic;
  List<WordModel> get words => _words;
  List<WordModel> get learnedWords => _learnedWords;
  List<WordModel> get masteredWords => _masteredWords;
  WordModel get currentWord => (_words.length > 0)
      ? _words[_currentIndex]
      : WordModel(createTime: 0, updateTime: 0);
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get autoPlayVoice => _autoPlayVoice;
  String get currentFillter => _currentFillter;

  String _generateUniqueId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomValue = _random.nextInt(1000);
    return 'w$timestamp$randomValue';
  }

  void setWords(List<WordModel> words) {
    _words = words;
    _learnedWords.clear();
    _masteredWords.clear();
    _currentIndex = 0;
    notifyListeners();
  }

  void toggleAutoPlayVoice() {
    _autoPlayVoice = !_autoPlayVoice;
    notifyListeners();
  }

  void setTopic(TopicModel topic) {
    _topic = topic;
    notifyListeners();
  }

  void showNextCard({required bool isMastered}) {
    if (_currentIndex < _words.length - 1) {
      if (isMastered) {
        _masteredWords.add(currentWord);
      } else {
        _learnedWords.add(currentWord);
      }
      _currentIndex++;
      if (_autoPlayVoice) {
        AppTTS.speak(currentWord.english != null
            ? currentWord.english!
            : "text to speak");
      }
      notifyListeners();
    }
  }

  void showPreviousCard() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _learnedWords.remove(currentWord);
      _masteredWords.remove(currentWord);
      if (_autoPlayVoice) {
        AppTTS.speak(currentWord.english != null
            ? currentWord.english!
            : "text to speak");
      }

      notifyListeners();
    }
  }

  Future<void> markWord(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _wordRepository.mark(
          topic.id, currentWord.id!, userId, !currentWord.isMarked);
      _isLoading = false; // Cập nhật lại trạng thái sau khi tải xong
      notifyListeners();
    } catch (e) {
      _isLoading = false; // Cập nhật lại trạng thái nếu có lỗi
      print('Error fetching topics: $e');
      notifyListeners();
    }
  }

  void fetchWordsByStatus(
      String userId, String topicId, WordStatus status) async {
    _isLoading = true;
    notifyListeners();

    _wordRepository.getAllByStatus(userId, topicId, status,
        (List<WordModel> words) {
      if (words.length > 0) {
        _words = words;
      } else {
        commonToast('Không có từ nào phù hợp!');
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  void fillter(String filter, String userID) {
    _currentFillter = filter;
    String topicID = _topic.id;
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

  void clearWords() {
    _words.clear();
  }

  void shuffle() {
    final sublist = _words.sublist(currentIndex);
    sublist.shuffle();
    _words.replaceRange(currentIndex, _words.length, sublist);
    notifyListeners();
  }
}
