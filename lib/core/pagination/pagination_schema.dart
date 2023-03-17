import '../schema/basic_schema.dart';
import '../schema/schema.dart';
import 'pagination.dart';

final paginationRequestSchema = Schema<PaginationRequest>(
  "PaginationRequest",
  {
    "page": BasicSchema(type: "integer"),
    "perPage": BasicSchema(type: "integer"),
    "filter": BasicSchema(type: "string"),
  },
  (obj) => PaginationRequest.fromJson(obj),
);

class PaginationResponseSchema<T> extends Schema<PaginationResponse<T>> {
  PaginationResponseSchema(
    Schema<T> typeSchema,
  ) : super(
          "PaginationRequest_${typeSchema.name}",
          {
            "page": BasicSchema(type: "integer", minValue: 0),
            "perPage": BasicSchema(type: "integer", minValue: 1),
            "filter": BasicSchema(type: "string"),
            "data": BasicSchema(many: typeSchema),
            "count": BasicSchema(type: "integer", minValue: 0),
            "total": BasicSchema(type: "integer", minValue: 0),
          },
          (dynamic json) {
            final data = (json['data'] as List)
                .map(typeSchema.entityConstructor)
                .toList();

            return PaginationResponse(
              filter: json['filter'],
              page: json['page'],
              perPage: json['perPage'],
              total: json['total'],
              data: data,
            );
          },
        );
}
