import 'package:book_notes/api/auth/login.dart';
import 'package:book_notes/api/auth/registry.dart';
import 'package:book_notes/api/auth/verify.dart';
import 'package:book_notes/core/access.dart';

class AuthApi {
  final login = LoginEndpoint();
  final registry = RegistryEndpoint();
  final verify = VerifyEndpoint();
}
