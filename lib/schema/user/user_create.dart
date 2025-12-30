import '../../core/schema/schema_view.dart';
import '../../domain/user/user_create.dart';
import 'user.dart';

final userCreateSchema = SchemaView(
  "UserCreate",
  userSchema,
  [
    SchemaViewField(name: "username"),
    SchemaViewField(name: "name"),
  ],
  (data) => UserCreate.fromJson(data),
);
