import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../domain/user/user.dart';
import 'permission.dart';

class JwtService {
  final String secret;

  JwtService(this.secret);

  String generateToken(User user) {
    final jwt = JWT({
      'sub': user.userId,
      'username': user.username,
      'group': user.userGroupId,
    });

    return jwt.sign(SecretKey(secret), expiresIn: Duration(hours: 4));
  }

  JWT verifyToken(String token) {
    try {
      return JWT.verify(token, SecretKey(secret));
    } catch (e) {
      throw Exception('Invalid token');
    }
  }
}
