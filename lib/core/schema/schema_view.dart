import '../exception/validation_exception.dart';
import 'schema.dart';
import 'schema_base.dart';

class SchemaViewField {
  final String name;
  final bool nullable;
  final bool identity;

  SchemaViewField({
    required this.name,
    this.nullable = false,
    this.identity = false,
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
      if (obj.containsKey(field.name)) {
        if (field.nullable && obj[field.name] == null) continue;
        base.fields[field.name]!.validate(obj[field.name]);
      } else if (!field.nullable) {
        throw ValidationException(
          "Invalid object does not has field '${field.name}'",
        );
      }
    }
  }
}
