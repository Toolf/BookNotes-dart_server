import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/action/action.dart';
import '../../domain/action/action_create.dart';
import '../../domain/action/action_update.dart';
import '../../schema/action/action.dart';
import '../../schema/action/action_create.dart';
import '../../schema/action/action_update.dart';
import 'notes.dart';

class ActionApi {
  final CrudlApi<Action, ActionCreate, ActionUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  final NotesEndpoint notes;

  ActionApi._(
    DB db,
    this.notes,
  ) : _crudl = CrudlApi<Action, ActionCreate, ActionUpdate>(
          datasource: db.action,
          entitySchema: actionSchema,
          entityUpdateSchema: actionUpdateSchema,
          entityCreateSchema: actionCreateSchema,
          tags: ["Action"],
        );

  factory ActionApi(DB db) {
    return ActionApi._(db, NotesEndpoint(db));
  }
}
