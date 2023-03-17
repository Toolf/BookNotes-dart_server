import '../../core/crudl_api.dart';
import '../../db/relationship_datasource.dart';
import '../../domain/relationship/relationship.dart';
import '../../domain/relationship/relationship_create.dart';
import '../../domain/relationship/relationship_update.dart';
import '../../schema/relationship/relationship.dart';
import '../../schema/relationship/relationship_create.dart';
import '../../schema/relationship/relationship_update.dart';

class RelationshipApi {
  final CrudlApi<Relationship, RelationshipCreate, RelationshipUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  RelationshipApi._(
    RelationshipDataSource dataSource,
  ) : _crudl = CrudlApi<Relationship, RelationshipCreate, RelationshipUpdate>(
          datasource: dataSource,
          entitySchema: relationshipSchema,
          entityUpdateSchema: relationshipUpdateSchema,
          entityCreateSchema: relationshipCreateSchema,
        );

  factory RelationshipApi(RelationshipDataSource dataSource) {
    return RelationshipApi._(
      dataSource,
    );
  }
}
