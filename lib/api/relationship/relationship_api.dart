import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/relationship/relationship.dart';
import '../../domain/relationship/relationship_create.dart';
import '../../domain/relationship/relationship_update.dart';
import '../../schema/relationship/relationship.dart';
import '../../schema/relationship/relationship_create.dart';
import '../../schema/relationship/relationship_update.dart';
import 'read.dart';

class RelationshipApi {
  final CrudlApi<Relationship, RelationshipCreate, RelationshipUpdate> _crudl;
  final DB db;

  get create => _crudl.create;
  get read => RelationReadEndpoint(db, ["Relationship"]);
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  RelationshipApi._(
    this.db,
  ) : _crudl = CrudlApi<Relationship, RelationshipCreate, RelationshipUpdate>(
          datasource: db.relationship,
          entitySchema: relationshipSchema,
          entityUpdateSchema: relationshipUpdateSchema,
          entityCreateSchema: relationshipCreateSchema,
          tags: ["Relationship"],
        );

  factory RelationshipApi(DB db) {
    return RelationshipApi._(db);
  }
}
