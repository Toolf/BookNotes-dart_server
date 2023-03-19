import '../../core/pagination/pagination.dart';

class NotePaginationRequest extends PaginationRequest {
  final int actionId;

  NotePaginationRequest({
    required this.actionId,
    required int page,
    required int perPage,
    required String filter,
  }) : super(
          page: page,
          perPage: perPage,
          filter: filter,
        );

  factory NotePaginationRequest.fromJson(Map<String, dynamic> json) {
    return NotePaginationRequest(
      actionId: json['actionId'],
      filter: json['filter'] ?? '',
      page: json['page'],
      perPage: json['perPage'],
    );
  }
}
