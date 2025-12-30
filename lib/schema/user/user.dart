import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/user/user.dart';

final userSchema = Schema(
  "User",
  {
    "userId": BasicSchema(type: "integer"),
    "username": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "name": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "createAt": BasicSchema(type: "date"),
    "updateAt": BasicSchema(type: "date"),
  },
  (data) => User.fromJson(data),
);
