import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../domain/auth/model/json_web_token.dart';

final jsonWebTokenSchema = Schema<JsonWebToken>(
  "JsonWebToken",
  {
    "accessToken": BasicSchema(type: "string"),
    "expiry": BasicSchema(type: "date", nullable: true),
    "refreshToken": BasicSchema(type: "string"),
    "tokenType": BasicSchema(type: "string"),
  },
  (data) => JsonWebToken.fromJson(data), // TODO
);
