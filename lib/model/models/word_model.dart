class WordModel {
  String? id;
  String? english;
  String? vietnamese;
  String? answer;
  bool? isCorrect;
  bool isMarked;
  int createTime;
  int updateTime;
  String? imageUrl;
  Map<String, dynamic> statusByUser;
  Map<String, bool> bookmarkByUser;

  WordModel({
    this.id,
    this.english,
    this.vietnamese,
    this.answer,
    this.isCorrect,
    this.isMarked = false,
    required this.createTime,
    required this.updateTime,
    this.imageUrl,
    this.statusByUser = const {},
    this.bookmarkByUser = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'english': english,
      'vietnamese': vietnamese,
      'createTime': createTime,
      'updateTime': updateTime,
      'imageUrl': imageUrl,
      'statusByUser': statusByUser,
      'bookmarkByUser': bookmarkByUser,
    };
  }

  static WordModel fromMap(Map<String, dynamic> map, String id) {
    return WordModel(
      id: id,
      english: map['english'],
      vietnamese: map['vietnamese'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
      imageUrl: map['imageUrl'],
      statusByUser: Map<String, dynamic>.from(map['statusByUser']),
      bookmarkByUser: Map<String, bool>.from(map['bookmarkByUser']),
    );
  }
}
