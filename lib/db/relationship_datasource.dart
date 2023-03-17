import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/relationship/relationship.dart';
import '../domain/relationship/relationship_create.dart';
import '../domain/relationship/relationship_update.dart';
import '../schema/relationship/relationship.dart';
import '../schema/relationship/relationship_create.dart';
import '../schema/relationship/relationship_update.dart';

class RelationshipDataSource extends PostgresCrudlDatasource<Relationship,
    RelationshipCreate, RelationshipUpdate> {
  @override
  String get tableName => 'Relationship';

  RelationshipDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (actionJson) => Relationship.fromJson(actionJson),
          relationshipSchema,
          relationshipCreateSchema,
          relationshipUpdateSchema,
          connectionFactory,
        );
}
