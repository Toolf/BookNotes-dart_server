import '../../core/pagination/pagination.dart';

class RelationshipPaginationRequest extends PaginationRequest {
  final int characterId;

  RelationshipPaginationRequest({
    required this.characterId,
    required int page,
    required int perPage,
    required String filter,
  }) : super(
          page: page,
          perPage: perPage,
          filter: filter,
        );

  factory RelationshipPaginationRequest.fromJson(Map<String, dynamic> json) {
    return RelationshipPaginationRequest(
      characterId: json['characterId'],
      filter: json['filter'] ?? '',
      page: json['page'],
      perPage: json['perPage'],
    );
  }
}
