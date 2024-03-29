import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../core/exception/db_exception.dart';
import '../core/pagination/pagination.dart';
import '../domain/action/action.dart';
import '../domain/book/action_pagination_request.dart';
import '../domain/book/book.dart';
import '../domain/book/book_create.dart';
import '../domain/book/book_update.dart';
import '../domain/book/character_pagination_request.dart';
import '../domain/character/character.dart';
import '../schema/action/action.dart';
import '../schema/book/book.dart';
import '../schema/book/book_create.dart';
import '../schema/book/book_update.dart';
import '../schema/character/character.dart';

class BookDataSource
    extends PostgresCrudlDatasource<Book, BookCreate, BookUpdate> {
  @override
  String get tableName => 'Book';

  BookDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (bookJson) => Book.fromJson(bookJson),
          bookSchema,
          bookCreateSchema,
          bookUpdateSchema,
          connectionFactory,
        );

  Future<PaginationResponse<Character>> characters(
    CharacterPaginationRequest request,
  ) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = characterSchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
          "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
          "FROM \"Character\" "
          "WHERE \"bookId\" = @bookId "
          "LIMIT @limit OFFSET @offset ",
          substitutionValues: {
            "bookId": request.bookId,
            "limit": request.perPage,
            "offset": request.page * request.perPage,
          },
        );
        final characters = res.map((characterMap) {
          final characterData = characterMap["Character"]!;
          return Character.fromJson(characterData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM \"Character\" "
          "WHERE \"bookId\" = @bookId ",
          substitutionValues: {
            "bookId": request.bookId,
          },
        );
        final total = totalResult.first.first;

        return PaginationResponse(
          data: characters,
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
        throw DbException("Invalid characters operation", e);
      }
    } finally {
      await connection.close();
    }
  }

  Future<PaginationResponse<Action>> actions(
    ActionPaginationRequest request,
  ) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = actionSchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
          "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
          "FROM \"Action\" "
          "WHERE \"bookId\" = @bookId "
          "LIMIT @limit OFFSET @offset ",
          substitutionValues: {
            "bookId": request.bookId,
            "limit": request.perPage,
            "offset": request.page * request.perPage,
          },
        );
        final actions = res.map((actionMap) {
          final actionData = actionMap["Action"]!;
          return Action.fromJson(actionData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM \"Action\" "
          "WHERE \"bookId\" = @bookId ",
          substitutionValues: {
            "bookId": request.bookId,
          },
        );
        final total = totalResult.first.first;

        return PaginationResponse(
          data: actions,
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
        throw DbException("Invalid actions operation", e);
      }
    } finally {
      await connection.close();
    }
  }
}
