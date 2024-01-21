class TopicModel {
  String? id;
  String? title;
  String? description;
  int wordCount;
  int viewCount;
  bool isPublic;
  String? author;
  dynamic authorRef;
  int createTime;
  int updateTime;

  TopicModel({
    this.id,
    this.title,
    this.description,
    this.wordCount = 0,
    this.viewCount = 0,
    this.isPublic = false,
    this.author,
    this.authorRef,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'wordCount': wordCount,
      'viewCount': viewCount,
      'isPublic': isPublic,
      'author': author,
      'authorRef': authorRef,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  static TopicModel fromMap(Map<String, dynamic> map, String id) {
    return TopicModel(
      id: id,
      title: map['title'],
      description: map['description'],
      wordCount: map['wordCount'],
      viewCount: map['viewCount'],
      isPublic: map['isPublic'],
      author: map['author'],
      authorRef: map['authorRef'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
    );
  }
}
