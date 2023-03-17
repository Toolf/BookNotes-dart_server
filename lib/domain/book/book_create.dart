class BookCreate {
  const BookCreate({
    required this.title,
    required this.description,
  });
  final String title;
  final String description;

  static BookCreate fromJson(Map<String, dynamic> json) {
    return BookCreate(
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
