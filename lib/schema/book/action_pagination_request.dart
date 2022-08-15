import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../domain/book/action_pagination_request.dart';

final actionPaginationRequestSchema = Schema<ActionPaginationRequest>(
  "ActionPaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
    "bookId": BasicSchema(type: "integer"),
  },
  (obj) => ActionPaginationRequest.fromJson(obj),
);
