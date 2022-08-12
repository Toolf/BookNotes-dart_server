import '../exception/validation_exception.dart';
import 'schema_base.dart';

class BasicSchema<T> extends SchemaBase<T> {
  final String? type;
  final int? lengthMin;
  final int? lengthMax;
  final int? minValue;
  final int? maxValue;
  final bool unique = false;
  final String note = "";
  final String? one;
  final SchemaBase? many;

  BasicSchema({
    this.type = 'ref',
    this.lengthMin,
    this.lengthMax,
    this.minValue,
    this.maxValue,
    this.one,
    this.many,
  }) : super(type ?? 'ref', (obj) => obj as T);

  @override
  validate(dynamic obj) {
    if (many != null) {
      if (obj is! List) {
        throw ValidationException(
          "Invalid object type is '${obj.runtimeType}' "
          "expected 'list'",
        );
      }
      for (var element in obj) {
        many!.validate(element);
      }
      return;
    }

    switch (type) {
      case "string":
        if (obj is! String) {
          throw ValidationException(
            "Invalid object type is '${obj.runtimeType}' "
            "expected 'string'",
          );
        }

        break;
      case "integer":
        if (obj is! int) {
          throw ValidationException(
            "Invalid object type is '${obj.runtimeType}' "
            "expected 'integer'",
          );
        }
        break;
      case "boolean":
        if (obj is! bool) {
          throw ValidationException(
            "Invalid object type is '${obj.runtimeType}' "
            "expected 'boolean'",
          );
        }
        break;
      default:
        throw ValidationException("Unknown object `$obj` type");
    }
  }
}

final stringSchema = BasicSchema<String>(type: "string");
final intSchema = BasicSchema<int>(type: "integer");
final boolSchema = BasicSchema<bool>(type: "boolean");
