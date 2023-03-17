import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../core/exception/db_exception.dart';
import '../core/pagination/pagination.dart';
import '../domain/character/character.dart';
import '../domain/character/character_create.dart';
import '../domain/character/character_update.dart';
import '../domain/character/relationship_pagination_request.dart';
import '../domain/relationship/relationship.dart';
import '../schema/character/character.dart';
import '../schema/character/character_create.dart';
import '../schema/character/character_update.dart';
import '../schema/relationship/relationship.dart';

class CharacterDataSource extends PostgresCrudlDatasource<Character,
    CharacterCreate, CharacterUpdate> {
  @override
  String get tableName => 'Character';

  CharacterDataSource(PostgresConnectionFactory connectionFactory)
      : super(
          (characterJson) => Character.fromJson(characterJson),
          characterSchema,
          characterCreateSchema,
          characterUpdateSchema,
          connectionFactory,
        );

  Future<PaginationResponse<Relationship>> relationships(
    RelationshipPaginationRequest request,
  ) async {
    final connection = connectionFactory.createConnection();
    try {
      await connection.open();
      final fieldsNames = relationshipSchema.fields.entries
          .where((f) => !f.value.related)
          .map((f) => f.key)
          .toList();
      return await connection.transaction((conn) async {
        final res = await conn.mappedResultsQuery(
          "SELECT ${fieldsNames.map((f) => '"$f"').join(', ')} "
          "FROM \"${relationshipSchema.name}\" "
          "WHERE \"fromCharacterId\" = @characterId "
          "  OR \"toCharacterId\" = @characterId "
          "LIMIT @limit OFFSET @offset ",
          substitutionValues: {
            "characterId": request.characterId,
            "limit": request.perPage,
            "offset": request.page * request.perPage,
          },
        );
        final relationships = res.map((actionMap) {
          final relationshipData = actionMap[relationshipSchema.name]!;
          return Relationship.fromJson(relationshipData);
        }).toList();

        final totalResult = await conn.query(
          "SELECT COUNT(*) "
          "FROM \"${relationshipSchema.name}\" "
          "WHERE \"fromCharacterId\" = @characterId "
          "  OR \"toCharacterId\" = @characterId ",
          substitutionValues: {
            "characterId": request.characterId,
          },
        );
        final total = totalResult.first.first;

        return PaginationResponse(
          data: relationships,
          filter: request.filter,
          page: request.page,
          perPage: request.perPage,
          total: total,
        );
      });
    } catch (e) {
      if (e is DbException) {
        rethrow;
      } else {
        throw DbException("Invalid relationships operation", e);
      }
    } finally {
      await connection.close();
    }
  }
}
