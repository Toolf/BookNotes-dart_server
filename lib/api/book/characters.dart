import '../../db/db.dart';
import '../../schema/book/character_pagination_request.dart';
import '../../schema/character/character.dart';

import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../core/pagination/pagination_schema.dart';
import '../../domain/book/character_pagination_request.dart';
import '../../domain/character/character.dart';

class CharactersEndpoint extends Endpoint<CharacterPaginationRequest,
    PaginationResponse<Character>> {
  final DB db;

  CharactersEndpoint(this.db);

  @override
  get parameters => characterPaginationRequestSchema;
  @override
  get returns => PaginationResponseSchema(characterSchema);
  @override
  get tags => ["Book"];

  @override
  Future<PaginationResponse<Character>> method(
    CharacterPaginationRequest request,
  ) async {
    final characters = await db.book.characters(request);
    return characters;
  }

  @override
  void validate(PaginationRequest request) {}
}
