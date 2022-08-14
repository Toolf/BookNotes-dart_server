import 'package:book_notes/schema/book/character_pagination_request.dart';
import 'package:book_notes/schema/character/character.dart';

import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../core/pagination/pagination_schema.dart';
import '../../db/book_datasource.dart';
import '../../domain/book/character_pagination_request.dart';
import '../../domain/character/character.dart';

class CharactersEndpoint extends Endpoint<CharacterPaginationRequest,
    PaginationResponce<Character>> {
  final BookDataSource dataSource;

  CharactersEndpoint(this.dataSource);

  @override
  get parameters => characterPaginationRequestSchema;
  @override
  get returns => PaginationResponceSchema(characterSchema);

  @override
  Future<PaginationResponce<Character>> method(
    CharacterPaginationRequest request,
  ) async {
    final characters = await dataSource.characters(request);
    return characters;
  }

  @override
  void validate(PaginationRequest request) {}
}
