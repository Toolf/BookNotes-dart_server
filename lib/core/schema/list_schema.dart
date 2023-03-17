import 'package:book_notes/core/schema/basic_shema.dart';
import 'package:book_notes/core/schema/schema.dart';

class ListSchema<Entity> extends BasicSchema<List<Entity>> {
  final BasicSchema<Entity> entitySchema;
  ListSchema(this.entitySchema)
      : super(
          many: entitySchema as Schema<dynamic>,
        );
}
