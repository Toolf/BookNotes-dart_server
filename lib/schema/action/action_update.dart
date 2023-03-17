import '../../core/schema/schema_view.dart';
import '../../domain/action/action_update.dart';
import 'action.dart';

final actionUpdateSchema = SchemaView(
  "ActionUpdate",
  actionSchema,
  [
    SchemaViewField(name: "actionId", identity: true),
    SchemaViewField(name: "title", nullable: true),
    SchemaViewField(name: "description", nullable: true),
  ],
  (data) => ActionUpdate.fromJson(data),
);
