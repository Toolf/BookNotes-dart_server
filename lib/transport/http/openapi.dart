import 'package:book_notes/core/endpoint.dart';
import 'package:book_notes/core/schema/basic_schema.dart';
import 'package:book_notes/core/schema/schema.dart';
import 'package:book_notes/core/schema/schema_base.dart';
import 'package:book_notes/core/schema/schema_view.dart';

class OpenApiSchema {
  final String title;
  final String version;
  final String openapiVersion;
  final Map<String, Endpoint> endpoints;

  OpenApiSchema({
    required this.title,
    required this.version,
    this.openapiVersion = "3.1.0",
    required this.endpoints,
  });

  Set<SchemaBase> getInnerSchemas(SchemaBase schema) {
    final allSchemas = <SchemaBase>{};
    final queue = <SchemaBase>[schema];

    while (queue.isNotEmpty) {
      final current = queue.removeLast();

      if (current is BasicSchema) {
        final relatedSchema = current.one ?? current.many;
        if (relatedSchema != null && allSchemas.add(relatedSchema)) {
          queue.add(relatedSchema);
        }
      } else if (current is Schema) {
        for (var field in current.fields.values) {
          if (field is BasicSchema &&
              field.isObject &&
              allSchemas.add((field.one ?? field.many)!)) {
            queue.add((field.one ?? field.many)!);
          }
          if (field is MapSchema) {
            if (allSchemas.add(field.keySchema)) {
              queue.add(field.keySchema);
            }
            if (allSchemas.add(field.valueSchema)) {
              queue.add(field.valueSchema);
            }
          }
        }
      } else if (current is SchemaView) {
        if (allSchemas.add(current.base)) {
          queue.add(current.base);
        }
      }
    }

    return allSchemas.where((schema) => schema is! BasicSchema).toSet();
  }

  List<SchemaBase> getEndpointSchemas() {
    final initialSchemas = <SchemaBase>{};

    for (var e in endpoints.values) {
      final returns = e.returns;
      if (returns != null && returns is! BasicSchema) {
        initialSchemas.add(returns);
      }

      final params = e.parameters;
      if (params != null && params is! BasicSchema) initialSchemas.add(params);
    }

    final allSchemas = <SchemaBase>{};
    final queue = List<SchemaBase>.from(initialSchemas);

    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      if (allSchemas.add(current)) {
        for (var inner in getInnerSchemas(current)) {
          if (!allSchemas.contains(inner)) {
            queue.add(inner);
          }
        }
      }
    }

    final sorted = allSchemas.toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return sorted;
  }

  Map<String, dynamic> toJson() {
    final info = <String, dynamic>{
      "title": title,
      "version": version,
    };
    final output = <String, dynamic>{
      "openapi": openapiVersion,
      "info": info,
      "paths": {
        for (final endpointPath in endpoints.keys)
          "/$endpointPath": {
            "post": {
              if (endpoints[endpointPath]!.caption != null)
                "summary": endpoints[endpointPath]!.caption,
              if (endpoints[endpointPath]!.description != null)
                "description": endpoints[endpointPath]!.description,
              "operationId": endpointPath,
              if (endpoints[endpointPath]!.parameters != null)
                "requestBody": {
                  "content": {
                    "application/json": {
                      "schema": {
                        "type": "object",
                        "properties": {
                          "method": {
                            "type": "string",
                            "enum": [endpointPath],
                          },
                          "data":
                              endpoints[endpointPath]!.parameters is BasicSchema
                                  ? OpenapiSchemaBase(
                                          endpoints[endpointPath]!.parameters!)
                                      .toJson()
                                  : {
                                      "\$ref":
                                          "#/components/schemas/${endpoints[endpointPath]!.parameters!.name}"
                                    }
                        }
                      }
                    }
                  },
                  "required": true
                },
              if (endpoints[endpointPath]!.returns != null)
                "responses": {
                  "200": {
                    "description": "Successful Response",
                    "content": {
                      "application/json": {
                        "schema": {
                          "type": "object",
                          "properties": {
                            "method": {
                              "type": "string",
                              "enum": [endpointPath],
                            },
                            "data":
                                endpoints[endpointPath]!.returns is BasicSchema
                                    ? OpenapiSchemaBase(
                                            endpoints[endpointPath]!.returns!)
                                        .toJson()
                                    : {
                                        "\$ref":
                                            "#/components/schemas/${endpoints[endpointPath]!.returns!.name}"
                                      }
                          }
                        }
                      }
                    }
                  },
                },
              if (endpoints[endpointPath]!.tags.isNotEmpty)
                "tags": endpoints[endpointPath]!.tags
            }
          }
      },
      "components": {
        "schemas": {
          for (final schema in getEndpointSchemas())
            schema.name: OpenapiSchemaBase(schema).toJson(),
        }
      }
    };

    return output;
  }
}

abstract class OpenapiSchemaBase {
  factory OpenapiSchemaBase(SchemaBase schema) {
    if (schema is BasicSchema) {
      return OpenapiBasicSchema(schema);
    }
    if (schema is Schema) {
      return OpenapiSchema(schema);
    }
    if (schema is SchemaView) {
      return OpenapiSchemaView(schema);
    }
    if (schema is MapSchema) {
      return OpenapiMapSchema(schema);
    }
    if (schema is EnumSchema) {
      return OpenapiEnumSchema(schema);
    }

    throw Exception("Unexpected schema type ${schema.runtimeType}");
  }

  Map<String, dynamic> toJson();
}

class OpenapiBasicSchema implements OpenapiSchemaBase {
  final BasicSchema schema;

  OpenapiBasicSchema(this.schema);

  @override
  Map<String, dynamic> toJson() {
    if (schema.isObject) {
      return schema.one == null
          ? {
              "\$ref": "#/components/schemas/${schema.many!.name}",
            }
          : {
              "items": {
                "\$ref": "#/components/schemas/${schema.one!.name}",
              },
              "type": "array",
              "title": schema.name,
            };
    }

    final jsonSchema = {
      "type": schema.type,
      "title": schema.name,
    };
    if (schema.many != null) {
      return {"type": "array", "title": schema.name, "items": jsonSchema};
    } else {
      return jsonSchema;
    }
  }
}

class OpenapiSchema implements OpenapiSchemaBase {
  final Schema schema;

  OpenapiSchema(this.schema);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "object",
      "title": schema.name,
      "properties": {
        for (final field in schema.fields.entries)
          field.key: OpenapiSchemaBase(field.value).toJson(),
      },
      "required": schema.fields.keys.toList(),
    };
  }
}

class OpenapiSchemaView implements OpenapiSchemaBase {
  final SchemaView schema;

  OpenapiSchemaView(this.schema);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "object",
      "title": schema.name,
      "properties": {
        for (final field in schema.fields.where((field) => schema.base.fields[field.name] is BasicSchema))
          field.name: (schema.base.fields[field.name] as BasicSchema).isObject
              ? "#/components/schemas/${field.name}"
              : OpenapiSchemaBase(schema.base.fields[field.name]!).toJson(),
        for (final field in schema.fields.where((field) => schema.base.fields[field.name] is! BasicSchema))
          field.name: "any"
      },
      "required":
          schema.fields.where((f) => !f.nullable).map((f) => f.name).toList()
    };
  }
}

class OpenapiMapSchema implements OpenapiSchemaBase {
  final MapSchema schema;

  OpenapiMapSchema(this.schema);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "object",
      "title": schema.name,
      "additionalProperties": OpenapiSchemaBase(schema.valueSchema).toJson(),
    };
  }
}

class OpenapiEnumSchema implements OpenapiSchemaBase {
  final EnumSchema schema;

  OpenapiEnumSchema(this.schema);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "string",
      "title": schema.name,
      "enum": schema.enumValues,
    };
  }
}
