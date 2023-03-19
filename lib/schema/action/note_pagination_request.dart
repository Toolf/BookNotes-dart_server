import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/action/note_pagination_request.dart';

final notePaginationRequestSchema = Schema<NotePaginationRequest>(
  "NotePaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
    "actionId": BasicSchema(type: "integer"),
  },
  (obj) => NotePaginationRequest.fromJson(obj),
);
