import '../../core/permission.dart';

class UserGroup {
  const UserGroup({
    required this.userGroupId,
    required this.name,
    required this.permissions,
    required this.createAt,
    required this.updateAt,
  });
  final int userGroupId;
  final Map<PermissionEntity, Set<PermissionAction>> permissions;
  final String name;
  final DateTime createAt;
  final DateTime updateAt;
  
  static UserGroup fromJson(Map<String, dynamic> json) {
    final Map<PermissionEntity, Set<PermissionAction>> permissions = {};

    ((json['permissions'] ?? {}) as Map<String, List<String>>).forEach((entityKey, actionsValue) {
      final entity = PermissionEntity.fromRaw(entityKey);

      final actions = actionsValue
          .map((a) => PermissionAction.fromRaw(a.trim()))
          .toSet();

      permissions[entity] = actions;
    });
    
    return UserGroup(
      userGroupId: json['userGroupId'],
      name: json['name'],
      permissions: permissions,
      createAt: json['createAt'] is DateTime
          ? json['createAt']
          : DateTime.tryParse(json['createAt']),
      updateAt: json['updateAt'] is DateTime
          ? json['updateAt']
          : DateTime.tryParse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userGroupId': userGroupId,
      'name': name,
      'createAt': createAt.toString(),
      'updateAt': updateAt.toString(),
    };
  }
}
