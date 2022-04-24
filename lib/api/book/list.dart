import '../../core/pagination/pagination.dart';
import '../../core/endpoint.dart';
import '../../db/book_datasource.dart';
import '../../domain/book/book.dart';

class ListEndpoint
    extends Endpoint<PaginationRequest, PaginationResponce<Book>> {
  final BookDataSource bookDataSource;
  ListEndpoint(this.bookDataSource);

  @override
  Future<PaginationResponce<Book>> method(PaginationRequest request) {
    return bookDataSource.list(request);
  }

  @override
  void validate(data) {}
}
