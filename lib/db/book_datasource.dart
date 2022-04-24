import '../core/crudl_api.dart';
import '../core/pagination/pagination.dart';
import '../domain/book/book.dart';
import '../domain/book/book_create.dart';
import '../domain/book/book_update.dart';
import 'db.dart';

class BookDataSource extends CrudlDatasource<Book, BookCreate, BookUpdate> {
  static String tableName = '"Book"';
  static String identityName = '"bookId"';

  @override
  Future<int> create(BookCreate book) async {
    final connection = db.pg.createConnection();
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
      await connection.close();
      rethrow;
    }
  }

  @override
  Future<Book> read(int bookId) async {
    final connection = db.pg.createConnection();
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
      await connection.close();
      rethrow;
    }
  }

  @override
  Future<Book> delete(int bookId) async {
    final connection = db.pg.createConnection();
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
      await connection.close();
      rethrow;
    }
  }

  @override
  Future<PaginationResponce<Book>> list(PaginationRequest request) {
    // TODO: implement list
    throw UnimplementedError();
  }

  @override
  Future<Book> update(BookUpdate book) async {
    final connection = db.pg.createConnection();
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
      await connection.close();
      rethrow;
    }
  }
}
