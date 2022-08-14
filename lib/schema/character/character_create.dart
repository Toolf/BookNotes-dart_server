import '../../core/schema/schema_view.dart';
import '../../domain/character/character_create.dart';
import 'character.dart';

final characterCreateSchema = SchemaView(
  "CharacterCreate",
  characterSchema,
  [
    SchemaViewField(name: "name"),
    SchemaViewField(name: "description"),
    SchemaViewField(name: "bookId"),
  ],
  (data) => CharacterCreate.fromJson(data),
);
