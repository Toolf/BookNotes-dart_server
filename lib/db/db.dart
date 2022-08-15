import '../config/config.dart';
import '../core/db/pg.dart';
import 'action_datasource.dart';
import 'book_datasource.dart';
import 'character_datasource.dart';

class DB {
  final BookDataSource bookDataSource;
  final CharacterDataSource characterDataSource;
  final ActionDataSource actionDataSource;

  DB._({
    required this.bookDataSource,
    required this.characterDataSource,
    required this.actionDataSource,
  });

  factory DB() {
    final pg = PostgreConnectionFactory(config.pgConfig);
    return DB._(
      bookDataSource: BookDataSource(pg),
      characterDataSource: CharacterDataSource(pg),
      actionDataSource: ActionDataSource(pg),
    );
  }
}

final db = DB();
