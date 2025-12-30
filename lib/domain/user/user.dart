class User {
  const User({
    required this.userId,
    required this.username,
    required this.name,
    required this.createAt,
    required this.updateAt,
    required this.userGroupId,
  });
  final int userId;
  final String username;
  final String name;
  final int? userGroupId;
  final DateTime createAt;
  final DateTime updateAt;

  static User fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      userGroupId: json['userGroupId'],
      createAt: json['createAt'] is DateTime
          ? json['createAt']
          : DateTime.tryParse(json['createAt']),
      updateAt: json['updateAt'] is DateTime
          ? json['updateAt']
          : DateTime.tryParse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'name': name,
      'userGroupId': userGroupId,
      'createAt': createAt.toString(),
      'updateAt': updateAt.toString(),
    };
  }
}
