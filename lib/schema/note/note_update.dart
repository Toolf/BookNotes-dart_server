import '../../core/schema/schema_view.dart';
import '../../domain/note/note_update.dart';
import 'note.dart';

final noteUpdateSchema = SchemaView(
  "NoteUpdate",
  noteSchema,
  [
    SchemaViewField(name: "noteId", identity: true),
    SchemaViewField(name: "actionId", nullable: true),
    SchemaViewField(name: "text", nullable: true),
  ],
  (data) => NoteUpdate.fromJson(data),
);
