import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/user/user.dart';
import '../domain/user/user_create.dart';
import '../domain/user/user_update.dart';
import '../schema/user/user.dart';
import '../schema/user/user_create.dart';
import '../schema/user/user_update.dart';

class UserDataSource
    extends PostgresCrudlDatasource<User, UserCreate, UserUpdate> {
  @override
  String get tableName => 'User';

  UserDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (userJson) => User.fromJson(userJson),
          userSchema,
          userCreateSchema,
          userUpdateSchema,
          connectionFactory,
        );
}
