import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:languageassistant/model/models/topic_model.dart';
import 'package:languageassistant/model/models/word_model.dart';
import 'package:languageassistant/model/repository/topic_repository.dart';
import 'package:languageassistant/utils/app_toast.dart';
import 'package:languageassistant/utils/app_validator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddTopicViewModel extends ChangeNotifier {
  List<TopicModel> _topics = [];
  List<WordModel> _words = [];

  final TopicRepository _topicRepository = TopicRepository();
  final Random _random = Random();
  bool _isLoading = false; // Thêm biến này

  List<TopicModel> get topics => _topics;
  bool get isLoading => _isLoading; // Thêm getter này
  List<WordModel> get words => _words;

  String _generateUniqueId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomValue = _random.nextInt(1000);
    return 'w$timestamp$randomValue';
  }

  void addEmptyTermField() {
    tz.TZDateTime nowInTimeZone =
        tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
    int currentTimestamp =
        (nowInTimeZone.millisecondsSinceEpoch / 1000).toInt();
    _words.add(WordModel(
        id: _generateUniqueId(),
        vietnamese: "",
        english: "",
        createTime: currentTimestamp,
        updateTime: currentTimestamp));
    notifyListeners();
  }

  void addTermField(String eng, String vi) {
    tz.TZDateTime nowInTimeZone =
        tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
    int currentTimestamp =
        (nowInTimeZone.millisecondsSinceEpoch / 1000).toInt();
    _words.add(WordModel(
        id: _generateUniqueId(),
        vietnamese: vi,
        english: eng,
        createTime: currentTimestamp,
        updateTime: currentTimestamp));
    notifyListeners();
  }

  void pickFile() async {
    await Permission.storage.request();
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    status = await Permission.storage.status;
    if (!status.isGranted) {
      print('Storage permission is denied');
      return;
    }
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    // print(result.files.first.name);
    final filePath = result.files.first.path!;

    final file = File(filePath);
    final lines = await file.readAsLines();

    final fields = lines.map((line) => line.split(',')).toList();
    // print(fields);
    _words.clear();
    for (var row in fields) {
      if (row.length >= 2) {
        final eng = row[0];
        final vi = row[1];
        addTermField(eng, vi);
      }
    }
  }

  void removeWord(WordModel wordModel) {
    _words.removeWhere((word) => word.id == wordModel.id);
    notifyListeners();
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

  Future<TopicModel?> saveAndShowWords(String title, String userID) async {
    final validators = [
      Validator.required(
          value: title, message: "Vui lòng không bỏ trống tiêu đề!"),
      Validator.min(
          min: 4,
          value: _words.length,
          message: "Chủ đề phải có ít nhất 4 từ vựng!"),
    ];

    for (var word in _words) {
      validators.addAll([
        Validator.required(
            value: word.english!,
            message: "Vui lòng không bỏ trống từ tiếng Anh!"),
        Validator.required(
            value: word.vietnamese!,
            message: "Vui lòng không bỏ trống từ tiếng Việt!"),
      ]);
    }

    final errorMessages =
        validators.where((validator) => validator != null).toList();
    if (errorMessages.isNotEmpty) {
      errorToast(errorMessages.first!);
      return null;
    }

    tz.TZDateTime nowInTimeZone =
        tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
    int currentTimesnap = nowInTimeZone.millisecondsSinceEpoch ~/ 1000;
    TopicModel _topic = TopicModel(
        id: "",
        title: title,
        description: '',
        wordCount: _words.length,
        viewCount: 0,
        public: false,
        author: userID,
        createTime: currentTimesnap,
        updateTime: currentTimesnap);
    try {
      final addedTopic = await createTopic(_topic, _words);
      return addedTopic;
    } catch (e) {
      print("Error saving topic: $e");
      return null;
    }
  }

  void clearWords() {
    _words.clear();
  }
}
