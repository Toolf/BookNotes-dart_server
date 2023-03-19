import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/note/note.dart';
import '../domain/note/note_create.dart';
import '../domain/note/note_update.dart';
import '../schema/note/note.dart';
import '../schema/note/note_create.dart';
import '../schema/note/note_update.dart';

class NoteDataSource
    extends PostgresCrudlDatasource<Note, NoteCreate, NoteUpdate> {
  @override
  String get tableName => 'Note';

  NoteDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (actionJson) => Note.fromJson(actionJson),
          noteSchema,
          noteCreateSchema,
          noteUpdateSchema,
          connectionFactory,
        );
}
