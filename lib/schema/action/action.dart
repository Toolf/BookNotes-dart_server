import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/action/action.dart';

final actionSchema = Schema(
  "Action",
  {
    "actionId": BasicSchema(type: "integer"),
    "title": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
    "bookId": BasicSchema(type: "integer"),
  },
  (data) => Action.fromJson(data),
);
