import 'schema_base.dart';

import 'schema.dart';

class SchemaViewField {
  final String name;
  final bool nullable;

  SchemaViewField({
    required this.name,
    this.nullable = false,
  });
}

class SchemaView<Entity> extends SchemaBase<Entity> {
  final Schema base;
  final List<SchemaViewField> fields;

  SchemaView(
    String name,
    this.base,
    this.fields,
    Entity Function(dynamic obj) entityConstructor,
  ) : super(name, entityConstructor);

  @override
  validate(obj) {
    if (obj is! Map) throw Exception("Invalid object for schema");
    for (var field in fields) {
      if (obj.containsKey(field)) {
        base.fields[field]!.validate(obj[field]);
      } else {
        throw Exception("Invalid object does not has field '$field'");
      }
    }
  }
}
