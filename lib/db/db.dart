import 'package:book_notes/db/note_datasource.dart';
import 'package:book_notes/db/user_datasource.dart';

import '../config/config.dart';
import '../core/db/pg.dart';
import 'action_datasource.dart';
import 'book_datasource.dart';
import 'character_datasource.dart';
import 'relationship_datasource.dart';
import 'user_group_datasource.dart';

class DB {
  final UserDataSource user;
  final UserGroupDataSource userGroup;
  final BookDataSource book;
  final CharacterDataSource character;
  final ActionDataSource action;
  final RelationshipDataSource relationship;
  final NoteDataSource note;

  DB({
    required this.user,
    required this.userGroup,
    required this.book,
    required this.character,
    required this.action,
    required this.relationship,
    required this.note,
  });

  factory DB.postgres() {
    final pg = PostgresConnectionFactory(config.pgConfig);
    return DB(
      user: UserDataSource(pg),
      userGroup: UserGroupDataSource(pg),
      book: BookDataSource(pg),
      character: CharacterDataSource(pg),
      action: ActionDataSource(pg),
      relationship: RelationshipDataSource(pg),
      note: NoteDataSource(pg),
    );
  }
}

final db = DB.postgres();
