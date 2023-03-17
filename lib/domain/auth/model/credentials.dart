class Credentials {
  const Credentials({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  static Credentials fromJson(Map<String, dynamic> json) {
    return Credentials(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
