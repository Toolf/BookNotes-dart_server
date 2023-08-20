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
          for (final schema in [
            ...endpoints.values
                .where((e) => e.returns != null)
                .where((e) => e.returns is! BasicSchema)
                .map(
                  (e) => e.returns!,
                ),
            ...endpoints.values
                .where((e) => e.parameters != null)
                .where((e) => e.parameters is! BasicSchema)
                .map(
                  (e) => e.parameters!,
                )
          ]..sort((e1, e2) => e1.name.compareTo(e2.name)))
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

    throw Exception("Unexpected schema type ${schema.runtimeType}");
  }

  Map<String, dynamic> toJson();
}

class OpenapiBasicSchema implements OpenapiSchemaBase {
  final BasicSchema schema;

  OpenapiBasicSchema(this.schema);

  @override
  Map<String, dynamic> toJson() {
    if (schema.related) {
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
        for (final field in schema.fields)
          field.name: schema.base.fields[field.name]!.related
              ? "#/components/schemas/${field.name}"
              : OpenapiSchemaBase(schema.base.fields[field.name]!).toJson(),
      },
      "required":
          schema.fields.where((f) => !f.nullable).map((f) => f.name).toList()
    };
  }
}
