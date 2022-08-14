import '../../core/crudl_api.dart';
import '../../db/book_datasource.dart';
import '../../domain/book/book.dart';
import '../../domain/book/book_create.dart';
import '../../domain/book/book_update.dart';
import '../../schema/book/book.dart';
import '../../schema/book/book_create.dart';
import '../../schema/book/book_update.dart';
import 'characters.dart';

class BookApi extends CrudlApi<Book, BookCreate, BookUpdate> {
  final CharactersEndpoint characters;

  BookApi._(
    BookDataSource dataSource,
    this.characters,
  ) : super(
          datasource: dataSource,
          entitySchema: bookSchema,
          entityUpdateSchema: bookUpdateSchema,
          entityCreateSchema: bookCreateSchema,
        );

  factory BookApi(BookDataSource dataSource) {
    return BookApi._(
      dataSource,
      CharactersEndpoint(dataSource),
    );
  }
}
