import 'package:book_notes/api/book/book_api.dart';
import 'package:book_notes/core/exception/validation_exception.dart';
import 'package:book_notes/domain/book/book_create.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../fixture/fixture_reader.dart';
import '../../mock/db/book_datasource_mock.dart';

void main() {
  final bookDataSource = BookDataSourceMock();

  final bookApi = BookApi(bookDataSource);

  group("Create Endpoint:", () {
    final bookCreateJson = fixture("db/book/book_create_fixture.json");
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
}
