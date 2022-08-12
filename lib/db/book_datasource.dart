import 'package:book_notes/schema/book/book.dart';
import 'package:book_notes/schema/book/book_create.dart';
import 'package:book_notes/schema/book/book_update.dart';

import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/book/book.dart';
import '../domain/book/book_create.dart';
import '../domain/book/book_update.dart';

class BookDataSource
    extends PostgresCrudlDatasource<Book, BookCreate, BookUpdate> {
  @override
  String get tableName => 'Book';
  @override
  String get identityName => 'bookId';

  BookDataSource(PostgreConnectionFactory connectionFactory)
      : super(
          (bookJson) => Book.fromJson(bookJson),
          bookSchema,
          bookCreateSchema,
          bookUpdateSchema,
          connectionFactory,
        );
}
