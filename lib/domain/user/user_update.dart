class UserUpdate {
  final int userId;
  final String? username;
  final String? name;
  final int? groupId;

  const UserUpdate({
    required this.userId,
    required this.username,
    required this.name,
    required this.groupId,
  });

  static UserUpdate fromJson(Map<String, dynamic> json) {
    return UserUpdate(
      userId: json['userId'],
      username: json['username'],
      name: json['name'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'name': name,
      'groupId': groupId,
    };
  }
}
