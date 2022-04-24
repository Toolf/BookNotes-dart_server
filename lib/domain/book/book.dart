class Book {
  const Book._({
    required this.bookId,
    required this.title,
    required this.description,
  });
  final int bookId;
  final String title;
  final String description;

  static Book fromJson(Map<String, dynamic> json) {
    return Book._(
      bookId: json['bookId'],
      title: json['title'],
      description: json['description'],
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
