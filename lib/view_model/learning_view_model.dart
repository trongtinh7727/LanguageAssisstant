import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/model/repository/word_repository.dart';
import 'package:languageassistant/routes/name_routes.dart';
import 'package:languageassistant/utils/app_enum.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_tts.dart';
import 'package:languageassistant/utils/date_time_util.dart';

class LearningViewModel extends ChangeNotifier {
  LearningMode _learningMode = LearningMode.FlashCard;

  late TopicModel _topic;
  List<WordModel> _words = [];
  List<WordModel> _currentOptions = [];
  List<WordModel> _learnedWords = [];
  List<WordModel> _masteredWords = [];
  int _currentIndex = 0;
  String _currentFillter = "Tất cả";

  final TopicRepository _topicRepository = TopicRepository();
  final WordRepository _wordRepository = WordRepository();
  final Random _random = Random();
  bool _isLoading = false;
  bool _autoPlayVoice = false;
  bool _isEnglishMode = true;

  TopicModel get topic => _topic;
  LearningMode get learningMode => _learningMode;
  List<WordModel> get words => _words;
  List<WordModel> get currentOptions => _currentOptions;
  List<WordModel> get learnedWords => _learnedWords;
  List<WordModel> get masteredWords => _masteredWords;
  WordModel get currentWord => (_words.length > 0)
      ? _words[_currentIndex]
      : WordModel(vietnamese: '', english: '', createTime: 0, updateTime: 0);
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get autoPlayVoice => _autoPlayVoice;
  bool get isEnglishMode => _isEnglishMode;
  String get currentFillter => _currentFillter;

  String _generateUniqueId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomValue = _random.nextInt(1000);
    return 'w$timestamp$randomValue';
  }

  void toggleAutoPlayVoice() {
    _autoPlayVoice = !_autoPlayVoice;
    notifyListeners();
  }

  void setTopic(TopicModel topic, LearningMode learningMode) {
    _topic = topic;
    _learnedWords.clear();
    _masteredWords.clear();
    _learningMode = learningMode;
    _currentIndex = 0;
    notifyListeners();
  }

  void showNextCard({required bool isMastered, required BuildContext context}) {
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
    } else {
      if (isMastered) {
        _masteredWords.add(currentWord);
      } else {
        _learnedWords.add(currentWord);
      }
      if (learningMode != LearningMode.FlashCard) {
        updateLearningStatus(FirebaseAuth.instance.currentUser!.uid);
      }
      Navigator.pushReplacementNamed(context, RouteName.resultScreen);
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

  void switchMode(bool state) {
    _isEnglishMode = state;
    notifyListeners();
  }

  Future<void> updateLearningStatus(String userID) async {
    int wordLearned = 0;
    List<WordModel> updatedWords = [];

    learnedWords.forEach((word) {
      word.statusByUser[userID] = WordStatus.LEARNED.name;
      updatedWords.add(word);
    });

    masteredWords.forEach((word) {
      word.statusByUser[userID] = WordStatus.MASTERED.name;
      wordLearned++;
      updatedWords.add(word);
    });
    _topic.wordLearned = wordLearned;
    _topic.viewCount++;

    await _topicRepository.updateLearningStatus(
      userID,
      topic,
      updatedWords,
      wordLearned,
      DateTimeUtil.getCurrentTimestamp(),
    );
  }

  Future<void> markWord(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await _wordRepository.mark(
          topic.id, currentWord.id!, userId, currentWord.isMarked);
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
        _currentIndex = 0;
        if (learningMode == LearningMode.MultipleChoice) {
          setCurrenOption();
        }
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
      case "Đã đánh dấu":
        fetchWordsByStatus(
          userID,
          topicID,
          WordStatus.MARKED,
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

  void setCurrenOption() {
    _currentOptions = getRandomWords();
  }

  List<WordModel> getRandomWords() {
    List<WordModel> randomWords = [];
    Random random = Random();

    if (_words.length <= 4) {
      List<WordModel> randomWords = [..._words];
      randomWords.shuffle();
      return randomWords;
    }

    while (randomWords.length < 3) {
      int randomIndex = random.nextInt(_words.length);
      if (randomIndex != _currentIndex &&
          !randomWords.contains(_words[randomIndex])) {
        randomWords.add(_words[randomIndex]);
      }
    }
    randomWords.add(_words[currentIndex]);
    randomWords.shuffle();

    return randomWords;
  }
}
