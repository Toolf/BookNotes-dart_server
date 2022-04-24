import 'pagination.dart';
import '../schema/schema.dart';

import '../schema/basic_shema.dart';
import '../schema/schema_base.dart';

final paginationRequestSchema = Schema<PaginationRequest>(
  "PaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
  },
  (obj) => PaginationRequest.fromJson(obj),
);

class PaginationResponceSchema<T> extends Schema<PaginationResponce<T>> {
  PaginationResponceSchema(
    SchemaBase<T> typeSchema,
  ) : super(
          "PaginationRequest_${typeSchema.name}",
          {
            "page": BasicSchema(type: "integer", minValue: 0),
            "perPage": BasicSchema(type: "integer", minValue: 1),
            "filter": BasicSchema(type: "string"),
            "data": BasicSchema(many: typeSchema.name),
            "count": BasicSchema(type: "integer", minValue: 0)
          },
          (dynamic json) {
            final data = (json['data'] as List)
                .map(typeSchema.entityConstructor)
                .toList();

            return PaginationResponce(
              filter: json['filter'],
              page: json['page'],
              perPage: json['perPage'],
              total: json['total'],
              data: data,
            );
          },
        );
}
