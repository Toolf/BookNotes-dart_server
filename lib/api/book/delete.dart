import '../../core/endpoint.dart';
import '../../core/schema/basic_shema.dart';
import '../../db/book_datasource.dart';
import '../../domain/book/book.dart';

class DeleteEndpoint extends Endpoint<int, Book> {
  final BookDataSource bookDataSource;
  DeleteEndpoint(this.bookDataSource);

  @override
  get parameters => intSchema;

  @override
  Future<Book> method(int bookId) {
    return bookDataSource.delete(bookId);
  }

  @override
  void validate(data) {}
}
