import '../../core/exception/validation_exception.dart';
import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../core/access.dart';
import '../../core/access_scheme.dart';
import '../../core/endpoint.dart';
import '../../domain/auth/model/json_web_token.dart';
import '../../schema/auth/json_web_token.dart';

class VerifyEndpoint extends Endpoint<JsonWebToken, List<Access>> {
  VerifyEndpoint();

  @override
  get parameters => jsonWebTokenSchema;
  @override
  get returns =>
      BasicSchema<List<Access>>(many: accessSchema as Schema<dynamic>);
  @override
  Access get access => Public();

  @override
  Future<List<Access>> method(
    JsonWebToken request,
  ) async {
    throw UnimplementedError(); // TODO
  }

  @override
  void validate(JsonWebToken request) {
    if (DateTime.now().compareTo(request.expiry) >= 0) {
      throw ValidationException("Token expires end");
    }
  }
}
