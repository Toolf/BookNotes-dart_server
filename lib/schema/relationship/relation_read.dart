import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/relationship/relationship_read.dart';

final relationCharacterViewSchema = Schema(
  "RelationCharacterView",
  {
    "characterId": BasicSchema(type: "integer"),
    "name": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
  },
  (data) => null,
);

final relationActionViewSchema = Schema(
  "RelationActionView",
  {
    "actionId": BasicSchema(type: "integer"),
    "title": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
  },
  (data) => null,
);

final relationshipViewSchema = Schema<RelationshipView>(
  "RelationshipView",
  {
    "relationshipId": BasicSchema(type: "integer"),
    "fromCharacter": BasicSchema(one: relationCharacterViewSchema),
    "toCharacter": BasicSchema(one: relationCharacterViewSchema),
    "description": BasicSchema(type: "string"),
    "action": BasicSchema(one: relationActionViewSchema),
  },
  (data) => null,
);
