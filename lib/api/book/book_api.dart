import 'package:book_notes/api/book/delete.dart';
import 'package:book_notes/api/book/update.dart';
import 'package:book_notes/db/book_datasource.dart';

import 'create.dart';
import 'list.dart';
import 'read.dart';

class BookApi {
  final CreateEndpoint create;
  final ReadEndpoint read;
  final UpdateEndpoint update;
  final DeleteEndpoint delete;
  final ListEndpoint list;

  BookApi._({
    required this.create,
    required this.read,
    required this.update,
    required this.delete,
    required this.list,
  });

  factory BookApi(BookDataSource dataSource) {
    return BookApi._(
      create: CreateEndpoint(dataSource),
      read: ReadEndpoint(dataSource),
      update: UpdateEndpoint(dataSource),
      delete: DeleteEndpoint(dataSource),
      list: ListEndpoint(dataSource),
    );
  }
}
