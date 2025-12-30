import '../../core/schema/schema_view.dart';
import '../../domain/user_group/user_group_create.dart';
import 'user_group.dart';

final userGroupCreateSchema = SchemaView(
  "UserGroupCreate",
  userGroupSchema,
  [
    SchemaViewField(name: "name"),
    SchemaViewField(name: "permission"),
  ],
  (data) => UserGroupCreate.fromJson(data),
);
