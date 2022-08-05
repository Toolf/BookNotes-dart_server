import 'package:book_notes/api/book/book_api.dart';
import 'package:book_notes/core/exception/validation_exception.dart';
import 'package:book_notes/domain/book/book.dart';
import 'package:book_notes/domain/book/book_create.dart';
import 'package:book_notes/domain/book/book_update.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fixture/fixture_reader.dart';
import '../../mock/db/book_datasource_mock.dart';

void main() {
  final bookDataSource = BookDataSourceMock();

  final bookApi = BookApi(bookDataSource);

  group("Create Endpoint:", () {
    final bookCreateJson = fixture("book/book_create_fixture.json");
    final bookCreate = BookCreate.fromJson(bookCreateJson);
    group("Validate parameters:", () {
      test('Given valid bookCreate model when validate then returns normaly',
          () async {
        // arrange
        // act
        // assert
        expect(
          () => bookApi.create.parameters!.validate(bookCreateJson),
          returnsNormally,
        );
      });
      test('Given invalid book create model when validate then throw exception',
          () async {
        // arrange
        final invalidBookCreateJson = {};
        // act
        // assert
        expect(
          () => bookApi.create.parameters!.validate(invalidBookCreateJson),
          throwsA(TypeMatcher<ValidationException>()),
        );
      });
    });

    group("Method:", () {
      test(
          'Given valid book create model when execute method then return bookId',
          () async {
        // arrange
        final expectedBookId = 2;
        when((() => bookDataSource.create(bookCreate)))
            .thenAnswer((_) => Future.value(expectedBookId));
        // act
        final bookId = await bookApi.create.method(bookCreate);
        // assert
        expect(bookId, expectedBookId);
      });
    });
  });

  group("Read Endpoint:", () {
    final bookJson = fixture("book/book_fixture.json");
    final book = Book.fromJson(bookJson);
    group("Validate parameters:", () {
      test('Given valid book id when validate then returns normaly', () async {
        // arrange
        // act
        // assert
        expect(
          () => bookApi.read.parameters!.validate(book.bookId),
          returnsNormally,
        );
      });
      test('Given invalid book id when validate then throw exception',
          () async {
        // arrange
        final invalidBookIdJson = {};
        // act
        // assert
        expect(
          () => bookApi.read.parameters!.validate(invalidBookIdJson),
          throwsA(TypeMatcher<ValidationException>()),
        );
      });
    });

    group("Method:", () {
      test('Given valid book id when execute method then return book',
          () async {
        // arrange
        final expectedBook = book;
        when((() => bookDataSource.read(expectedBook.bookId)))
            .thenAnswer((_) => Future.value(expectedBook));
        // act
        final actualBook = await bookApi.read.method(expectedBook.bookId);
        // assert
        expect(actualBook, expectedBook);
      });
    });
  });

  group("Update Endpoint:", () {
    final bookUpdateJson = fixture("book/book_update_fixture.json");
    final bookUpdatedJson = fixture("book/book_updated_fixture.json");
    final bookUpdate = BookUpdate.fromJson(bookUpdateJson);
    final bookUpdated = Book.fromJson(bookUpdatedJson);

    group("Validate parameters:", () {
      test('Given valid book update model when validate then returns normaly',
          () async {
        // arrange
        // act
        // assert
        expect(
          () => bookApi.update.parameters!.validate(bookUpdateJson),
          returnsNormally,
        );
      });
      test('Given invalid book update model when validate then throw exception',
          () async {
        // arrange
        final invalidBookUpdateJson = {};
        // act
        // assert
        expect(
          () => bookApi.update.parameters!.validate(invalidBookUpdateJson),
          throwsA(TypeMatcher<ValidationException>()),
        );
      });
    });

    group("Method:", () {
      test(
          'Given valid book update model when execute method then return updated book',
          () async {
        // arrange
        final expectedBook = bookUpdated;
        when((() => bookDataSource.update(bookUpdate)))
            .thenAnswer((_) => Future.value(expectedBook));
        // act
        final actualBook = await bookApi.update.method(bookUpdate);
        // assert
        expect(actualBook, expectedBook);
      });
    });
  });
}
