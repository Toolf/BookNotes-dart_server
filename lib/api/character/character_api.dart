import '../../core/crudl_api.dart';
import '../../db/character_datasource.dart';
import '../../domain/character/character.dart';
import '../../domain/character/character_create.dart';
import '../../domain/character/character_update.dart';
import '../../schema/character/character.dart';
import '../../schema/character/character_create.dart';
import '../../schema/character/character_update.dart';

class CharacterApi {
  final CrudlApi<Character, CharacterCreate, CharacterUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  CharacterApi._(
    CharacterDataSource dataSource,
  ) : _crudl = CrudlApi<Character, CharacterCreate, CharacterUpdate>(
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
