class CharacterUpdate {
  const CharacterUpdate({
    required this.characterId,
    required this.name,
    required this.description,
  });
  final int characterId;
  final String? name;
  final String? description;

  static CharacterUpdate fromJson(Map<String, dynamic> json) {
    return CharacterUpdate(
      characterId: json['characterId'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'name': name,
      'description': description,
    };
  }
}
