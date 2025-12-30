import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/user_group/user_group.dart';
import '../../domain/user_group/user_group_create.dart';
import '../../domain/user_group/user_group_update.dart';
import '../../schema/user_group/user_group.dart';
import '../../schema/user_group/user_group_create.dart';
import '../../schema/user_group/user_group_update.dart';

class UserGroupApi {
  final CrudlApi<UserGroup, UserGroupCreate, UserGroupUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  UserGroupApi._(
    DB db,
  ) : _crudl = CrudlApi<UserGroup, UserGroupCreate, UserGroupUpdate>(
          datasource: db.userGroup,
          entitySchema: userGroupSchema,
          entityUpdateSchema: userGroupUpdateSchema,
          entityCreateSchema: userGroupCreateSchema,
          tags: ["UserGroup"],
        );

  factory UserGroupApi(DB db) {
    return UserGroupApi._(db);
  }
}
