import '../../core/crudl_api.dart';
import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../db/character_datasource.dart';
import '../../db/db.dart';
import '../../domain/character/character.dart';
import '../../domain/character/character_create.dart';
import '../../domain/character/character_update.dart';
import '../../domain/character/relationship_pagination_request.dart';
import '../../domain/relationship/relationship.dart';
import '../../schema/character/character.dart';
import '../../schema/character/character_create.dart';
import '../../schema/character/character_update.dart';
import 'relationships.dart';

class CharacterApi {
  final CrudlApi<Character, CharacterCreate, CharacterUpdate> _crudl;

  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  final Endpoint<RelationshipPaginationRequest,
      PaginationResponse<Relationship>> relationships;

  CharacterApi._(
    DB db,
  )   : _crudl = CrudlApi<Character, CharacterCreate, CharacterUpdate>(
          datasource: db.character,
          entitySchema: characterSchema,
          entityUpdateSchema: characterUpdateSchema,
          entityCreateSchema: characterCreateSchema,
          tags: ["Character"],
        ),
        relationships = RelationshipsEndpoint(db);

  factory CharacterApi(DB db) {
    return CharacterApi._(db);
  }
}
