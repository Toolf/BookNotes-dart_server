import '../config/config.dart';
import '../core/db/pg.dart';
import 'book_datasource.dart';
import 'character_datasource.dart';

class DB {
  final BookDataSource bookDataSource;
  final CharacterDataSource characterDataSource;

  DB._({
    required this.bookDataSource,
    required this.characterDataSource,
  });

  factory DB() {
    final pg = PostgreConnectionFactory(config.pgConfig);
    return DB._(
      bookDataSource: BookDataSource(pg),
      characterDataSource: CharacterDataSource(pg),
    );
  }
}

final db = DB();
