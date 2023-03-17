import '../../core/pagination/pagination.dart';

class ActionPaginationRequest extends PaginationRequest {
  final int bookId;

  ActionPaginationRequest({
    required this.bookId,
    required int page,
    required int perPage,
    required String filter,
  }) : super(
          page: page,
          perPage: perPage,
          filter: filter,
        );

  factory ActionPaginationRequest.fromJson(Map<String, dynamic> json) {
    return ActionPaginationRequest(
      bookId: json['bookId'],
      filter: json['filter'] ?? '',
      page: json['page'],
      perPage: json['perPage'],
    );
  }
}
