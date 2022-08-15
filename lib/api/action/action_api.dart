import '../../core/crudl_api.dart';
import '../../db/action_datasource.dart';
import '../../domain/action/action.dart';
import '../../domain/action/action_create.dart';
import '../../domain/action/action_update.dart';
import '../../schema/action/action.dart';
import '../../schema/action/action_create.dart';
import '../../schema/action/action_update.dart';

class ActionApi {
  final CrudlApi<Action, ActionCreate, ActionUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  ActionApi._(
    ActionDataSource dataSource,
  ) : _crudl = CrudlApi<Action, ActionCreate, ActionUpdate>(
          datasource: dataSource,
          entitySchema: actionSchema,
          entityUpdateSchema: actionUpdateSchema,
          entityCreateSchema: actionCreateSchema,
        );

  factory ActionApi(ActionDataSource dataSource) {
    return ActionApi._(
      dataSource,
    );
  }
}
