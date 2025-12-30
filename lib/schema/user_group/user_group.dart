import '../../core/permission.dart';
import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/user_group/user_group.dart';

final permissionEntitySchema = EnumSchema<PermissionEntity>(
  'PermissionEntity',
  (value) {
    if (value is! String) return null;
    return PermissionEntity.fromRaw(value);
  },
  PermissionEntity.values.map((v) => v.name).toList(),
);

final permissionActionSchema = EnumSchema<PermissionAction>(
  'PermissionAction',
  (value) {
    if (value is! String) return null;
    return PermissionAction.fromRaw(value);
  },
  ["create", "read", "update", "delete", "all"],
);

final actionListSchema = BasicSchema<List<PermissionAction>>(
  many: permissionActionSchema,
);

final permissionsSchema = MapSchema<PermissionEntity, List<PermissionAction>>(
  name: 'permissions',
  keySchema: permissionEntitySchema,
  valueSchema: actionListSchema,
);

final userGroupSchema = Schema(
  "UserGroup",
  {
    "userGroupId": BasicSchema(type: "integer"),
    "name": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "permissions": permissionsSchema,
    "createAt": BasicSchema(type: "date"),
    "updateAt": BasicSchema(type: "date"),
  },
  (data) => UserGroup.fromJson(data),
);
