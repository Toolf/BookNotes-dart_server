import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/action/action.dart';
import '../domain/action/action_create.dart';
import '../domain/action/action_update.dart';
import '../schema/action/action.dart';
import '../schema/action/action_create.dart';
import '../schema/action/action_update.dart';

class ActionDataSource
    extends PostgresCrudlDatasource<Action, ActionCreate, ActionUpdate> {
  @override
  String get tableName => 'Action';

  ActionDataSource(PostgreConnectionFactory connectionFactory)
      : super(
          (actionJson) => Action.fromJson(actionJson),
          actionSchema,
          actionCreateSchema,
          actionUpdateSchema,
          connectionFactory,
        );
}
