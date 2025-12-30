import '../db/db.dart';
import '../domain/user/user.dart';
import '../domain/user_group/user_group.dart';
import 'exception/api_exception.dart';

enum PermissionEntity {
  user,
  userGroup,
  acl;


  static PermissionEntity fromRaw(String value) {
    return PermissionEntity.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw FormatException('Unknown entity: $value'),
    );
  }
}


class PermissionAction {
  final String name;
  const PermissionAction._(this.name);

  static const create = PermissionAction._('create');
  static const read = PermissionAction._('read');
  static const update = PermissionAction._('update');
  static const delete = PermissionAction._('delete');
  static const all = PermissionAction._('all');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PermissionAction && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;

  static PermissionAction fromRaw(String value) {
    switch (value) {
      case 'create':
        return PermissionAction.create;
      case 'read':
        return PermissionAction.read;
      case 'update':
        return PermissionAction.update;
      case 'delete':
        return PermissionAction.delete;
      case 'all':
        return PermissionAction.all;
      default:
        return PermissionAction._(value);
    }
  }
}


extension UserGroupPermission on UserGroup {
  bool allows(PermissionEntity entity, PermissionAction action) {
    final actions = permissions[entity];
    if (actions == null) return false;

    return actions.contains(PermissionAction.all) || actions.contains(action);
  }
}

extension UserPermission on User {
  Future<bool> get isAclAdmin async {
    if (userGroupId == null){
      return false;
    }
    final group = await db.userGroup.read(userGroupId!);
    return group.allows(PermissionEntity.acl, PermissionAction.all);
  }

  Future<bool> can(PermissionEntity entity, PermissionAction action) async {
    if (userGroupId == null){
      return false;
    }
    final group = await db.userGroup.read(userGroupId!);
    return group.allows(PermissionEntity.acl, PermissionAction.all) || group.allows(entity, action);
  }
}

class ACL {
  static Future<void> require(
    User user,
    PermissionEntity entity,
    PermissionAction action,
  ) async {
    if (!await user.can(entity, action)) {
      throw ForbiddenException('$entity:$action denied');
    }
  }
}
