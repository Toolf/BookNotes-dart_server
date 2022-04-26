import '../exception/validation_exception.dart';
import 'basic_shema.dart';
import 'schema_base.dart';

class Schema<Entity> extends SchemaBase<Entity> {
  final Map<String, BasicSchema> fields;

  Schema(
    String name,
    this.fields,
    Entity Function(dynamic obj) entityConstructor,
  ) : super(name, entityConstructor);

  @override
  validate(dynamic obj) {
    if (obj is! Map) throw Exception("Invalid object for schema");
    for (var field in fields.keys) {
      if (obj.containsKey(field)) {
        fields[field]!.validate(obj[field]);
      } else {
        throw ValidationException("Invalid object does not has field '$field'");
      }
    }
  }
}
