import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../domain/auth/model/credentials.dart';

final credentialsSchema = Schema<Credentials>(
  "Credentials",
  {
    "username": BasicSchema(type: "string"),
    "password": BasicSchema(type: "string"),
  },
  (data) => Credentials.fromJson(data), // TODO
);
