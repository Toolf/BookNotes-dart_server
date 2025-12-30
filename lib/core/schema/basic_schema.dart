import '../exception/validation_exception.dart';
import 'schema.dart';
import 'schema_base.dart';

class BasicSchema<T> extends SchemaBase<T> {
  final String? type;
  final int? lengthMin;
  final int? lengthMax;
  final int? minValue;
  final int? maxValue;
  final bool unique = false;
  final String note = "";
  final SchemaBase? one;
  final SchemaBase? many;

  bool get isObject => one != null || many != null;

  BasicSchema({
    this.type = 'object',
    this.lengthMin,
    this.lengthMax,
    this.minValue,
    this.maxValue,
    this.one,
    this.many,
  }) : super(type ?? 'object', (obj) => obj as T);

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
    if (one != null) {
      one!.validate(obj);
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
      case "date":
        if (obj is! DateTime &&
            !(obj is String && DateTime.tryParse(obj) != null)) {
          throw ValidationException(
            "Invalid object type is '${obj.runtimeType}' "
            "expected 'DateTime' or 'string'",
          );
        }
        break;
      default:
        throw ValidationException("Unknown object `$obj` type");
    }
  }
}

class EnumSchema<T> extends SchemaBase<T> {
  final List enumValues;
  EnumSchema(super.name, super.parse, this.enumValues);

  @override
  void validate(dynamic obj) {
    if (parse(obj) == null) {
      throw ValidationException(
        '$name: invalid value "$obj"',
      );
    }
  }
}

class MapSchema<K, V> extends SchemaBase<Map<K, V>> {
  final SchemaBase<K> keySchema;
  final SchemaBase<V> valueSchema;

  MapSchema({
    required String name,
    required this.keySchema,
    required this.valueSchema,
  }) : super(name);

  @override
  void validate(dynamic obj) {
    if (obj is! Map) {
      throw ValidationException('$name must be a map');
    }

    obj.forEach((k, v) {
      keySchema.validate(k);
      valueSchema.validate(v);
    });
  }

  @override
  Map<K, V> parse(dynamic obj) {
    validate(obj);

    final map = obj as Map<dynamic, dynamic>;
    final result = <K, V>{};

    map.forEach((k, v) {
      result[keySchema.parse(k)!] = valueSchema.parse(v)!;
    });

    return result;
  }
}



final stringSchema = BasicSchema<String>(type: "string");
final intSchema = BasicSchema<int>(type: "integer");
final boolSchema = BasicSchema<bool>(type: "boolean");
