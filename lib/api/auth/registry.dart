import 'package:book_notes/core/access.dart';

import '../../domain/auth/model/json_web_token.dart';
import '../../schema/auth/credentials.dart';
import '../../schema/auth/json_web_token.dart';

import '../../core/endpoint.dart';
import '../../domain/auth/model/credentials.dart';

class RegistryEndpoint extends Endpoint<Credentials, JsonWebToken> {
  RegistryEndpoint();

  @override
  get parameters => credentialsSchema;
  @override
  get returns => jsonWebTokenSchema;
  @override
  Access get access => Public();

  @override
  Future<JsonWebToken> method(
    Credentials request,
  ) async {
    throw UnimplementedError(); // TODO
  }

  @override
  void validate(Credentials request) {}
}
