import '../core/db/pg.dart';
import '../core/db/postgres_crudl_datasource.dart';
import '../domain/character/character.dart';
import '../domain/character/character_create.dart';
import '../domain/character/character_update.dart';
import '../schema/character/character.dart';
import '../schema/character/character_create.dart';
import '../schema/character/character_update.dart';

class CharacterDataSource extends PostgresCrudlDatasource<Character,
    CharacterCreate, CharacterUpdate> {
  @override
  String get tableName => 'Character';

  CharacterDataSource(PostgreConnectionFactory connectionFactory)
      : super(
          (characterJson) => Character.fromJson(characterJson),
          characterSchema,
          characterCreateSchema,
          characterUpdateSchema,
          connectionFactory,
        );
}
