import '../../core/schema/schema_view.dart';
import '../../domain/user_group/user_group_update.dart';
import 'user_group.dart';

final userGroupUpdateSchema = SchemaView(
  "UserGroupUpdate",
  userGroupSchema,
  [
    SchemaViewField(name: "userGroupId", identity: true),
    SchemaViewField(name: "name", nullable: true),
    SchemaViewField(name: "permissions", nullable: true),
  ],
  (data) => UserGroupUpdate.fromJson(data),
);
