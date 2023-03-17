import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/relationship/relationship.dart';

final relationshipSchema = Schema(
  "Relationship",
  {
    "relationshipId": BasicSchema(type: "integer"),
    "fromCharacterId": BasicSchema(type: "integer"),
    "toCharacterId": BasicSchema(type: "integer"),
    "description": BasicSchema(type: "string"),
    "actionId": BasicSchema(type: "integer"),
  },
  (data) => Relationship.fromJson(data),
);
