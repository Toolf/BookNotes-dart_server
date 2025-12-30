import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/user/user.dart';
import '../../domain/user/user_create.dart';
import '../../domain/user/user_update.dart';
import '../../schema/user/user.dart';
import '../../schema/user/user_create.dart';
import '../../schema/user/user_update.dart';

class UserApi {
  final CrudlApi<User, UserCreate, UserUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  UserApi._(
    DB db,
  ) : _crudl = CrudlApi<User, UserCreate, UserUpdate>(
          datasource: db.user,
          entitySchema: userSchema,
          entityUpdateSchema: userUpdateSchema,
          entityCreateSchema: userCreateSchema,
          tags: ["User"],
        );

  factory UserApi(DB db) {
    return UserApi._(db);
  }
}
