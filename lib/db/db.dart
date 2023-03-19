import 'package:book_notes/db/note_datasource.dart';

import '../config/config.dart';
import '../core/db/pg.dart';
import 'action_datasource.dart';
import 'book_datasource.dart';
import 'character_datasource.dart';
import 'relationship_datasource.dart';

class DB {
  final BookDataSource bookDataSource;
  final CharacterDataSource characterDataSource;
  final ActionDataSource actionDataSource;
  final RelationshipDataSource relationshipDataSource;
  final NoteDataSource noteDataSource;

  DB._({
    required this.bookDataSource,
    required this.characterDataSource,
    required this.actionDataSource,
    required this.relationshipDataSource,
    required this.noteDataSource,
  });

  factory DB() {
    final pg = PostgresConnectionFactory(config.pgConfig);
    return DB._(
      bookDataSource: BookDataSource(pg),
      characterDataSource: CharacterDataSource(pg),
      actionDataSource: ActionDataSource(pg),
      relationshipDataSource: RelationshipDataSource(pg),
      noteDataSource: NoteDataSource(pg),
    );
  }
}

final db = DB();
