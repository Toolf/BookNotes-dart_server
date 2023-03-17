import '../exception/validation_exception.dart';
import 'schema_base.dart';

class MultiTypeSchema<BaseType> extends SchemaBase<BaseType> {
  final Map<String, SchemaBase<BaseType>> schemas;

  MultiTypeSchema(
    String baseTypeName,
    this.schemas,
  ) : super(baseTypeName,
            (obj) => schemas[obj['objectType']!]!.entityConstructor(obj));

  @override
  validate(obj) {
    if (obj is! Map) throw Exception("Invalid object for schema");
    if (!obj.containsKey('objectType')) {
      throw ValidationException(
        "Invalid object does not has field 'type'",
      );
    }
    if (!schemas.containsKey(obj['objectType'])) {
      throw ValidationException(
        "Unknow type '${obj['objectType']}'",
      );
    }
    return schemas[obj['objectType']]!.validate(obj);
  }
}
