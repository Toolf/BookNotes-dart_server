class PaginationRequest {
  final int page;
  final int perPage;
  final String filter;

  PaginationRequest({
    required this.page,
    required this.perPage,
    required this.filter,
  });

  factory PaginationRequest.fromJson(Map<String, dynamic> json) {
    return PaginationRequest(
      filter: json['filter'] ?? '',
      page: json['page'],
      perPage: json['perPage'],
    );
  }
}

class PaginationResponce<Entity> {
  final int page;
  final int perPage;
  final int total;
  final String filter;
  final List<Entity> data;

  int get count => data.length; // Count in current page

  PaginationResponce({
    required this.filter,
    required this.page,
    required this.perPage,
    required this.total,
    required this.data,
  });
}
