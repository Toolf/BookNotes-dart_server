import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../core/pagination/pagination_schema.dart';
import '../../db/book_datasource.dart';
import '../../domain/action/action.dart';
import '../../domain/book/action_pagination_request.dart';
import '../../schema/action/action.dart';
import '../../schema/book/action_pagination_request.dart';

class ActionsEndpoint
    extends Endpoint<ActionPaginationRequest, PaginationResponse<Action>> {
  final BookDataSource dataSource;

  ActionsEndpoint(this.dataSource);

  @override
  get parameters => actionPaginationRequestSchema;
  @override
  get returns => PaginationResponseSchema(actionSchema);
  @override
  get tags => ["Book"];

  @override
  Future<PaginationResponse<Action>> method(
    ActionPaginationRequest request,
  ) async {
    final actions = await dataSource.actions(request);
    return actions;
  }

  @override
  void validate(PaginationRequest request) {}
}
