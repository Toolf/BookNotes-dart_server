import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../domain/book/character_pagination_request.dart';

final characterPaginationRequestSchema = Schema<CharacterPaginationRequest>(
  "CharacterPaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
    "bookId": BasicSchema(type: "integer"),
  },
  (obj) => CharacterPaginationRequest.fromJson(obj),
);
