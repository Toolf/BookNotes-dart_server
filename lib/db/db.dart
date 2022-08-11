import '../config/config.dart';
import 'book_datasource.dart';
import '../core/db/pg.dart';

class DB {
  final BookDataSource bookDataSource;

  DB._({
    required this.bookDataSource,
  });

  factory DB() {
    final pg = PostgreConnectionFactory(config.pgConfig);
    return DB._(
      bookDataSource: BookDataSource(pg),
    );
  }
}

final db = DB();
