import '../../core/permission.dart';

class UserGroupUpdate {
  final int userGroupId;
  final String? name;
  final Map<PermissionEntity, Set<PermissionAction>> permissions;

  const UserGroupUpdate({
    required this.userGroupId,
    required this.name,
    required this.permissions,
  });

  static UserGroupUpdate fromJson(Map<String, dynamic> json) {
    final Map<PermissionEntity, Set<PermissionAction>> permissions = {};

    ((json['permissions'] ?? {}) as Map<String, List<String>>).forEach((entityKey, actionsValue) {
      final entity = PermissionEntity.fromRaw(entityKey);

      final actions = actionsValue
          .map((a) => PermissionAction.fromRaw(a.trim()))
          .toSet();

      permissions[entity] = actions;
    });

    return UserGroupUpdate(
      userGroupId: json['userGroupId'],
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
      'userGroupId': userGroupId,
      'permission': permissionsJson,
      'name': name,
    };
  }
}
