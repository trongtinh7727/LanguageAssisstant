class UserModel {
  String? id;
  String email;
  String name;
  String? avatarUrl;
  String? dataOfBirth;
  int createTime;
  int updateTime;

  UserModel({
    this.id,
    this.email = '',
    this.name = '',
    this.avatarUrl = "default_avatar_url",
    this.dataOfBirth,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'dataOfBirth': dataOfBirth,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'],
      name: map['name'],
      avatarUrl: map['avatarUrl'],
      dataOfBirth: map['dataOfBirth'],
      createTime: map['createTime'],
      updateTime: map['updateTime'],
    );
  }
}
