class Character {
  const Character({
    required this.characterId,
    required this.name,
    required this.description,
    required this.bookId,
  });
  final int characterId;
  final String name;
  final String description;
  final int bookId;

  static Character fromJson(Map<String, dynamic> json) {
    return Character(
      characterId: json['characterId'],
      name: json['name'],
      description: json['description'],
      bookId: json['bookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'name': name,
      'description': description,
      'bookId': bookId,
    };
  }
}
