import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/note/note.dart';
import '../../domain/note/note_create.dart';
import '../../domain/note/note_update.dart';
import '../../schema/note/note.dart';
import '../../schema/note/note_create.dart';
import '../../schema/note/note_update.dart';

class NoteApi {
  final CrudlApi<Note, NoteCreate, NoteUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  NoteApi._(
    DB db,
  ) : _crudl = CrudlApi<Note, NoteCreate, NoteUpdate>(
          datasource: db.note,
          entitySchema: noteSchema,
          entityUpdateSchema: noteUpdateSchema,
          entityCreateSchema: noteCreateSchema,
          tags: ["Note"],
        );

  factory NoteApi(DB db) {
    return NoteApi._(db);
  }
}
