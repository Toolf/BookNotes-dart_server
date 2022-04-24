import '../db/db.dart';
import 'book/book_api.dart';

class Api {
  final BookApi book;

  Api._({required this.book});

  factory Api() {
    return Api._(
      book: BookApi(db.bookDataSource),
    );
  }
}

final api = Api();
