class FolderModel {
  String? id;
  String? title;
  int topicCount;
  List<dynamic> topicRefs;
  int createTime;
  int updateTime;

  FolderModel({
    this.id,
    this.title,
    this.topicCount = 0,
    this.topicRefs = const [],
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'topicCount': topicCount,
      'topicRefs': topicRefs,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  static FolderModel fromMap(Map<String, dynamic> map, String id) {
    return FolderModel(
      id: id,
      title: map['title'],
      topicCount: map['topicCount'],
      topicRefs: List<dynamic>.from(map['topicRefs']),
      createTime: map['createTime'],
      updateTime: map['updateTime'],
    );
  }
}
