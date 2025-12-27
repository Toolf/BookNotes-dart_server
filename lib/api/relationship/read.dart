import '../../core/endpoint.dart';
import '../../core/exception/validation_exception.dart';
import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema_base.dart';
import '../../db/db.dart';
import '../../domain/relationship/relationship_read.dart';
import '../../schema/relationship/relation_read.dart';

class RelationReadEndpoint extends Endpoint<int, RelationshipView> {
  final DB db;
  final List<String> _tags;

  @override
  SchemaBase<int> get parameters => intSchema;
  @override
  SchemaBase<RelationshipView> get returns => relationshipViewSchema;
  @override
  List<String> get tags => _tags;

  RelationReadEndpoint(this.db, this._tags);

  @override
  Future<RelationshipView> method(int relationshipId) async {
    final relationship = await db.relationship.read(relationshipId);
    final fromCharacter = await db.character.read(relationship.fromCharacterId);
    final toCharacter = await db.character.read(relationship.toCharacterId);
    final action = await db.action.read(relationship.actionId);

    return RelationshipView(
      relationshipId: relationshipId,
      fromCharacter: RelationshipCharacterView(
        characterId: relationship.fromCharacterId,
        name: fromCharacter.name,
        description: fromCharacter.description,
      ),
      toCharacter: RelationshipCharacterView(
        characterId: relationship.toCharacterId,
        name: toCharacter.name,
        description: toCharacter.description,
      ),
      description: relationship.description,
      action: RelationshipActionView(
        actionId: relationship.actionId,
        title: action.title,
        description: action.description,
      ),
    );
  }

  @override
  void validate(int relationshipId) {
    if (relationshipId < 0) {
      throw ValidationException("Entity id must be positive number");
    }
  }
}
