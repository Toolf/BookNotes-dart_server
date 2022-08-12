import '../core/crudl_api.dart';
import '../core/db/pg.dart';
import '../core/exception/db_exception.dart';
import '../core/pagination/pagination.dart';
import '../domain/book/book.dart';
import '../domain/book/book_create.dart';
import '../domain/book/book_update.dart';

class BookDataSource extends CrudlDatasource<Book, BookCreate, BookUpdate> {
  final PostgreConnectionFactory connectionFactory;
  static String tableName = '"Book"';
  static String identityName = '"bookId"';

  BookDataSource(this.connectionFactory);

  @override
  Future<int> create(BookCreate book) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final res = await connection.mappedResultsQuery(
          "INSERT INTO $tableName (title, description) "
          "VALUES (@title:varchar, @description:varchar) "
          "RETURNING $identityName",
          substitutionValues: {
            "title": book.title,
            "description": book.description,
          });
      return res.single["Book"]!["bookId"] as int;
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid create operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Book> read(int bookId) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final res = await connection.mappedResultsQuery(
          "SELECT $identityName, title, description "
          "FROM $tableName "
          "WHERE $identityName = @bookId ",
          substitutionValues: {
            "bookId": bookId,
          });
      final bookData = res.single["Book"]!;
      return Book.fromJson(bookData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid read operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Book> delete(int bookId) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final res = await connection.mappedResultsQuery(
          "DELETE "
          "FROM $tableName "
          "WHERE $identityName = @bookId "
          "RETURNING *;",
          substitutionValues: {
            "bookId": bookId,
          });
      final bookData = res.single["Book"]!;
      return Book.fromJson(bookData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid delete operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<PaginationResponce<Book>> list(PaginationRequest request) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
            "SELECT $identityName, title, description "
            "FROM $tableName "
            "LIMIT @limit OFFSET @offset ",
            substitutionValues: {
              "limit": request.perPage,
              "offset": request.page * request.perPage,
            });
        final books = res.map((bookMap) {
          final bookData = bookMap["Book"]!;
          return Book.fromJson(bookData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM $tableName",
        );
        final total = totalResult.first.first;

        return PaginationResponce<Book>(
          filter: request.filter,
          page: request.page,
          perPage: request.perPage,
          total: total,
          data: books,
        );
      });
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid list operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }

  @override
  Future<Book> update(BookUpdate book) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final res = await connection.mappedResultsQuery(
          "UPDATE $tableName"
          "SET "
          "  title = COALESCE(@title, title), "
          "  description = COALESCE(@description, description) "
          "WHERE $identityName = @bookId "
          "RETURNING *;",
          substitutionValues: {
            "bookId": book.bookId,
            'title': book.title,
            'description': book.description,
          });
      final bookData = res.single["Book"]!;
      return Book.fromJson(bookData);
    } catch (e) {
      if (e is Error || e is Exception) {
        throw DbException("Invalid update operation", e);
      } else {
        rethrow;
      }
    } finally {
      await connection.close();
    }
  }
}
