class ActionCreate {
  const ActionCreate({
    required this.bookId,
    required this.title,
    required this.description,
  });
  final String title;
  final String description;
  final int bookId;

  static ActionCreate fromJson(Map<String, dynamic> json) {
    return ActionCreate(
      title: json['title'],
      description: json['description'],
      bookId: json['bookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'description': description,
    };
  }
}
