import 'book_datasource.dart';
import 'pg.dart';

class DB {
  final PostgreConnectionFactory pg;

  final BookDataSource bookDataSource;

  DB._({
    required this.pg,
    required this.bookDataSource,
  });

  factory DB() {
    return DB._(
      pg: PostgreConnectionFactory(),
      bookDataSource: BookDataSource(),
    );
  }
}

final db = DB();
