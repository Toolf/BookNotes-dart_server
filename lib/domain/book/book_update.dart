class BookUpdate {
  final int bookId;
  final String? title;
  final String? description;

  const BookUpdate({
    required this.bookId,
    required this.title,
    required this.description,
  });

  static BookUpdate fromJson(Map<String, dynamic> json) {
    return BookUpdate(
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
