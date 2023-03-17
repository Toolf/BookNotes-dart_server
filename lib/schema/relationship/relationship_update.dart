import '../../core/schema/schema_view.dart';
import '../../domain/relationship/relationship_update.dart';
import 'relationship.dart';

final relationshipUpdateSchema = SchemaView(
  "RelationshipUpdate",
  relationshipSchema,
  [
    SchemaViewField(name: "relationshipId", identity: true),
    SchemaViewField(name: "fromCharacterId", nullable: true),
    SchemaViewField(name: "toCharacterId", nullable: true),
    SchemaViewField(name: "description", nullable: true),
    SchemaViewField(name: "actionId", nullable: true),
  ],
  (data) => RelationshipUpdate.fromJson(data),
);
