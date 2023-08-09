import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../core/pagination/pagination_schema.dart';
import '../../db/character_datasource.dart';
import '../../domain/character/relationship_pagination_request.dart';
import '../../domain/relationship/relationship.dart';
import '../../schema/character/relationship_pagination_request.dart';
import '../../schema/relationship/relationship.dart';

class RelationshipsEndpoint extends Endpoint<RelationshipPaginationRequest,
    PaginationResponse<Relationship>> {
  final CharacterDataSource dataSource;

  RelationshipsEndpoint(this.dataSource);

  @override
  get parameters => relationshipPaginationRequestSchema;
  @override
  get returns => PaginationResponseSchema(relationshipSchema);
  @override
  get tags => ["Character"];

  @override
  Future<PaginationResponse<Relationship>> method(
    RelationshipPaginationRequest request,
  ) async {
    final relationship = await dataSource.relationships(request);
    return relationship;
  }

  @override
  void validate(PaginationRequest request) {}
}
