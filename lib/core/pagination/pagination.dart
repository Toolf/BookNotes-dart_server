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

class PaginationResponse<Entity> {
  final int page;
  final int perPage;
  final int total;
  final String filter;
  final List<Entity> data;

  int get count => data.length; // Count in current page

  PaginationResponse({
    required this.filter,
    required this.page,
    required this.perPage,
    required this.total,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'page': page,
      'perPage': perPage,
      'count': count,
      'total': total,
      'data': data,
    };
  }
}
