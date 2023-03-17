import '../../core/schema/schema_view.dart';
import '../../domain/action/action_create.dart';
import 'action.dart';

final actionCreateSchema = SchemaView(
  "ActionCreate",
  actionSchema,
  [
    SchemaViewField(name: "title"),
    SchemaViewField(name: "description"),
    SchemaViewField(name: "bookId"),
  ],
  (data) => ActionCreate.fromJson(data),
);
