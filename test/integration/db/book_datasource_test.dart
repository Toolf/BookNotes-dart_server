import 'package:book_notes/core/db/pg_config.dart';
import 'package:book_notes/core/exception/db_exception.dart';
import 'package:book_notes/db/book_datasource.dart';
import 'package:book_notes/core/db/pg.dart';
import 'package:book_notes/domain/book/book_create.dart';
import 'package:book_notes/domain/book/book_update.dart';
import 'package:test/test.dart';

import '../../fixture/fixture_reader.dart';

void main() {
  late BookDataSource bookDataSource;
  final tableName = "Book";

  final testPgConfig = PgConfig(
    url: "localhost",
    port: 5432,
    database: "testDb",
    username: "testUser",
    password: "testPassword",
  );
  final connectionFactory = PostgresConnectionFactory(testPgConfig);

  setUp(() {
    bookDataSource = BookDataSource(connectionFactory);
  });

  setUpAll(() async {
    final connection = connectionFactory.createConnection();
    await connection.open();
    await connection.execute("DELETE FROM \"$tableName\"");
  });

  group("Create book:", () {
    final bookCreateJson = fixture("book/book_create_fixture.json");
    final bookCreate = BookCreate.fromJson(bookCreateJson);
    test('When create book then in table must be added row', () async {
      // arrange
      // act
      final bookId = await bookDataSource.create(bookCreate);
      // assert
      final expexted = await bookDataSource.read(bookId);
      expect(bookCreate.description, expexted.description);
      expect(bookCreate.title, expexted.title);
      expect(bookId, expexted.bookId);
    });
  });

  group("Read book:", () {
    final bookCreateJson = fixture("book/book_create_fixture.json");
    final bookCreate = BookCreate.fromJson(bookCreateJson);
    test('Given book exists in database then it can be read', () async {
      // arrange
      final bookId = await bookDataSource.create(bookCreate);
      // act
      final res = await bookDataSource.read(bookId);
      // assert
      expect(res.description, bookCreate.description);
      expect(res.title, bookCreate.title);
      expect(res.bookId, bookId);
    });
  });

  group("Update book:", () {
    final bookCreateJson = fixture("book/book_create_fixture.json");
    final bookCreate = BookCreate.fromJson(bookCreateJson);
    final bookUpdateJson = fixture("book/book_update_fixture.json");
    test('Given book exists when update book then book fields update',
        () async {
      // arrange
      final bookId = await bookDataSource.create(bookCreate);
      bookUpdateJson['bookId'] = bookId;
      final bookUpdate = BookUpdate.fromJson(bookUpdateJson);
      // act
      final res = await bookDataSource.update(bookUpdate);
      // assert
      expect(res.description, bookUpdate.description);
      expect(res.title, bookUpdate.title);
      expect(res.bookId, bookId);
    });
  });

  group("Delete book:", () {
    final bookCreateJson = fixture("book/book_create_fixture.json");
    final bookCreate = BookCreate.fromJson(bookCreateJson);
    test('Given book exists when delete book then book must not exists',
        () async {
      // arrange
      final bookId = await bookDataSource.create(bookCreate);
      // act
      final res = await bookDataSource.delete(bookId);
      // assert
      expect(res.description, bookCreate.description);
      expect(res.title, bookCreate.title);
      expect(res.bookId, bookId);
      try {
        await bookDataSource.read(bookId);
        fail("Book must not exist");
      } catch (e) {
        expect(e, TypeMatcher<DbException>());
      }
    });
  });
}
