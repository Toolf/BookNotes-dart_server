import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/character/character.dart';

final characterSchema = Schema(
  "Character",
  {
    "characterId": BasicSchema(type: "integer"),
    "name": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
    "bookId": BasicSchema(type: "integer"),
  },
  (data) => Character.fromJson(data),
);
