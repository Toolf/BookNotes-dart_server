import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../core/exception/db_exception.dart';
import '../core/pagination/pagination.dart';
import '../domain/action/action.dart';
import '../domain/action/action_create.dart';
import '../domain/action/action_update.dart';
import '../domain/action/note_pagination_request.dart';
import '../domain/note/note.dart';
import '../schema/action/action.dart';
import '../schema/action/action_create.dart';
import '../schema/action/action_update.dart';
import '../schema/note/note.dart';

class ActionDataSource
    extends PostgresCrudlDatasource<Action, ActionCreate, ActionUpdate> {
  @override
  String get tableName => 'Action';

  ActionDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (actionJson) => Action.fromJson(actionJson),
          actionSchema,
          actionCreateSchema,
          actionUpdateSchema,
          connectionFactory,
        );

  Future<PaginationResponse<Note>> notes(
    NotePaginationRequest request,
  ) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = noteSchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
          "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
          "FROM \"Note\" "
          "WHERE \"actionId\" = @actionId "
          "LIMIT @limit OFFSET @offset ",
          substitutionValues: {
            "actionId": request.actionId,
            "limit": request.perPage,
            "offset": request.page * request.perPage,
          },
        );
        final notes = res.map((noteMap) {
          final noteData = noteMap["Note"]!;
          return Note.fromJson(noteData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM \"Note\" "
          "WHERE \"actionId\" = @actionId ",
          substitutionValues: {
            "actionId": request.actionId,
          },
        );
        final total = totalResult.first.first;

        return PaginationResponse(
          data: notes,
          filter: request.filter,
          page: request.page,
          perPage: request.perPage,
          total: total,
        );
      });
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid notes operation", e);
      }
    } finally {
      await connection.close();
    }
  }
}
