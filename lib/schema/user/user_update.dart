import '../../core/schema/schema_view.dart';
import '../../domain/user/user_update.dart';
import 'user.dart';

final userUpdateSchema = SchemaView(
  "UserUpdate",
  userSchema,
  [
    SchemaViewField(name: "userId", identity: true),
    SchemaViewField(name: "username", nullable: true),
    SchemaViewField(name: "name", nullable: true),
  ],
  (data) => UserUpdate.fromJson(data),
);
