import '../../core/schema/schema_view.dart';
import '../../domain/character/character_update.dart';
import 'character.dart';

final characterUpdateSchema = SchemaView(
  "CharacterUpdate",
  characterSchema,
  [
    SchemaViewField(name: "characterId", identity: true),
    SchemaViewField(name: "name", nullable: true),
    SchemaViewField(name: "description", nullable: true),
  ],
  (data) => CharacterUpdate.fromJson(data),
);
