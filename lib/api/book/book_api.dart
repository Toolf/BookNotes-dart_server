import '../../core/crudl_api.dart';
import '../../db/book_datasource.dart';
import '../../domain/book/book.dart';
import '../../domain/book/book_create.dart';
import '../../domain/book/book_update.dart';
import '../../schema/book/book.dart';
import '../../schema/book/book_create.dart';
import '../../schema/book/book_update.dart';

class BookApi extends CrudlApi<Book, BookCreate, BookUpdate> {
  BookApi(BookDataSource dataSource)
      : super(
          datasource: dataSource,
          entitySchema: bookSchema,
          entityUpdateSchema: bookUpdateSchema,
          entityCreateSchema: bookCreateSchema,
        );
}
