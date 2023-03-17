class JsonWebToken {
  const JsonWebToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
    required this.tokenType,
  });
  final String accessToken;
  final String refreshToken;
  final DateTime expiry;
  final String tokenType;

  static JsonWebToken fromJson(Map<String, dynamic> json) {
    return JsonWebToken(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expiry: json['expiry'] is DateTime
          ? json['expiry']
          : DateTime.tryParse(json['expiry']),
      tokenType: json['tokenType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiry': expiry.toString(),
      'tokenType': tokenType,
    };
  }
}
