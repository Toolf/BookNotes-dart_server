import 'book_datasource.dart';
import 'pg.dart';

class DB {
  final BookDataSource bookDataSource;

  DB._({
    required this.bookDataSource,
  });

  factory DB() {
    final pg = PostgreConnectionFactory();
    return DB._(
      bookDataSource: BookDataSource(pg),
    );
  }
}

final db = DB();
