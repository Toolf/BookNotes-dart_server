import '../../core/permission.dart';

class UserGroupCreate {
  final String name;
  final Map<PermissionEntity, Set<PermissionAction>> permissions;

  const UserGroupCreate({
    required this.name,
    required this.permissions,
  });

  static UserGroupCreate fromJson(Map<String, dynamic> json) {
    final Map<PermissionEntity, Set<PermissionAction>> permissions = {};

    ((json['permissions'] ?? {}) as Map<String, List<String>>).forEach((entityKey, actionsValue) {
      final entity = PermissionEntity.fromRaw(entityKey);

      final actions = actionsValue
          .map((a) => PermissionAction.fromRaw(a.trim()))
          .toSet();

      permissions[entity] = actions;
    });

    return UserGroupCreate(
      name: json['name'],
      permissions: permissions,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, List<String>> permissionsJson = {};
    permissions.forEach((entity, actions) {
      permissionsJson[entity.name] = actions.map((a) => a.name).toList();
    });
    return {
      'name': name,
      'permissions': permissionsJson,
    };
  }
}
