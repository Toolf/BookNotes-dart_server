import '../../core/pagination/pagination.dart';

class CharacterPaginationRequest extends PaginationRequest {
  final int bookId;

  CharacterPaginationRequest({
    required this.bookId,
    required int page,
    required int perPage,
    required String filter,
  }) : super(
          page: page,
          perPage: perPage,
          filter: filter,
        );

  factory CharacterPaginationRequest.fromJson(Map<String, dynamic> json) {
    return CharacterPaginationRequest(
      bookId: json['bookId'],
      filter: json['filter'] ?? '',
      page: json['page'],
      perPage: json['perPage'],
    );
  }
}
