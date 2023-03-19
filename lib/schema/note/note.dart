import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/note/note.dart';

final noteSchema = Schema(
  "Note",
  {
    "noteId": BasicSchema(type: "integer"),
    "actionId": BasicSchema(type: "integer"),
    "content": BasicSchema(type: "string"),
  },
  (data) => Note.fromJson(data),
);
