import '../../core/crudl_api.dart';
import '../../db/character_datasource.dart';
import '../../domain/character/character.dart';
import '../../domain/character/character_create.dart';
import '../../domain/character/character_update.dart';
import '../../schema/character/character.dart';
import '../../schema/character/character_create.dart';
import '../../schema/character/character_update.dart';

class CharacterApi
    extends CrudlApi<Character, CharacterCreate, CharacterUpdate> {
  CharacterApi._(
    CharacterDataSource dataSource,
  ) : super(
          datasource: dataSource,
          entitySchema: characterSchema,
          entityUpdateSchema: characterUpdateSchema,
          entityCreateSchema: characterCreateSchema,
        );

  factory CharacterApi(CharacterDataSource dataSource) {
    return CharacterApi._(
      dataSource,
    );
  }
}
