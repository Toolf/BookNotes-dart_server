import '../../db/book_datasource.dart';

import '../../core/endpoint.dart';
import '../../domain/book/book_create.dart';
import '../../schema/book/book_create.dart';

class CreateEndpoint extends Endpoint<BookCreate, int> {
  final BookDataSource bookDataSource;
  CreateEndpoint(this.bookDataSource);

  @override
  get parameters => bookCreateSchema;

  @override
  Future<int> method(BookCreate data) async {
    final bookId = bookDataSource.create(data);
    return bookId;
  }

  @override
  void validate(BookCreate data) {}
}
