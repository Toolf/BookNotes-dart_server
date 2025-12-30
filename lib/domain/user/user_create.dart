class UserCreate {
  final String username;
  final String name;
  final int groupId;

  const UserCreate({
    required this.username,
    required this.name,
    required this.groupId,
  });

  static UserCreate fromJson(Map<String, dynamic> json) {
    return UserCreate(
      username: json['username'],
      name: json['name'],
      groupId: json['groupId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'groupId': groupId,
    };
  }
}
