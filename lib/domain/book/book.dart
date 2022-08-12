class Book {
  const Book({
    required this.bookId,
    required this.title,
    required this.description,
    required this.createAt,
    required this.updateAt,
  });
  final int bookId;
  final String title;
  final String description;
  final DateTime createAt;
  final DateTime updateAt;

  static Book fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['bookId'],
      title: json['title'],
      description: json['description'],
      createAt: json['createAt'] is DateTime
          ? json['createAt']
          : DateTime.tryParse(json['createAt']),
      updateAt: json['updateAt'] is DateTime
          ? json['updateAt']
          : DateTime.tryParse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'title': title,
      'description': description,
      'createAt': createAt.toString(),
      'updateAt': updateAt.toString(),
    };
  }
}
