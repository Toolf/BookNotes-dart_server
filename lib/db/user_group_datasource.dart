import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/user_group/user_group.dart';
import '../domain/user_group/user_group_create.dart';
import '../domain/user_group/user_group_update.dart';
import '../schema/user_group/user_group.dart';
import '../schema/user_group/user_group_create.dart';
import '../schema/user_group/user_group_update.dart';

class UserGroupDataSource
    extends PostgresCrudlDatasource<UserGroup, UserGroupCreate, UserGroupUpdate> {
  @override
  String get tableName => 'UserGroup';

  UserGroupDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (userGroupJson) => UserGroup.fromJson(userGroupJson),
          userGroupSchema,
          userGroupCreateSchema,
          userGroupUpdateSchema,
          connectionFactory,
        );
}
