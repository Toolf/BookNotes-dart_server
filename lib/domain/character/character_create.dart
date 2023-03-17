class CharacterCreate {
  const CharacterCreate({
    required this.name,
    required this.description,
    required this.bookId,
  });
  final String name;
  final String description;
  final int bookId;

  static CharacterCreate fromJson(Map<String, dynamic> json) {
    return CharacterCreate(
      name: json['name'],
      description: json['description'],
      bookId: json['bookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'bookId': bookId,
    };
  }
}
