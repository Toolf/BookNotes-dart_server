import '../../db/book_datasource.dart';
import '../../domain/book/book_update.dart';

import '../../core/endpoint.dart';
import '../../domain/book/book.dart';
import '../../schema/book/book_update.dart';

class UpdateEndpoint extends Endpoint<BookUpdate, Book> {
  final BookDataSource bookDataSource;
  UpdateEndpoint(this.bookDataSource);

  @override
  get parameters => bookUpdateSchema;

  @override
  Future<Book> method(BookUpdate book) {
    return bookDataSource.update(book);
  }

  @override
  void validate(data) {}
}
