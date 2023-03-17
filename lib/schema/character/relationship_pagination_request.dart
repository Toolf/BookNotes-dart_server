import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';

import '../../domain/character/relationship_pagination_request.dart';

final relationshipPaginationRequestSchema =
    Schema<RelationshipPaginationRequest>(
  "RelationshipPaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
    "characterId": BasicSchema(type: "integer"),
  },
  (obj) => RelationshipPaginationRequest.fromJson(obj),
);
