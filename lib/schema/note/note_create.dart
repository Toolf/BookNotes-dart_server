import '../../core/schema/schema_view.dart';
import '../../domain/note/note_create.dart';
import 'note.dart';

final noteCreateSchema = SchemaView(
  "NoteCreate",
  noteSchema,
  [
    SchemaViewField(name: "actionId"),
    SchemaViewField(name: "content"),
  ],
  (data) => NoteCreate.fromJson(data),
);
