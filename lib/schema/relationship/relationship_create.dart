import '../../core/schema/schema_view.dart';
import '../../domain/relationship/relationship_create.dart';
import 'relationship.dart';

final relationshipCreateSchema = SchemaView(
  "RelationshipCreate",
  relationshipSchema,
  [
    SchemaViewField(name: "fromCharacterId"),
    SchemaViewField(name: "toCharacterId"),
    SchemaViewField(name: "description"),
    SchemaViewField(name: "actionId"),
  ],
  (data) => RelationshipCreate.fromJson(data),
);
