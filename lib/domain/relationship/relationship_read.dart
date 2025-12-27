class RelationshipCharacterView {
  final int characterId;
  final String name;
  final String description;

  RelationshipCharacterView({
    required this.characterId,
    required this.name,
    required this.description,
  });

  static RelationshipCharacterView fromJson(Map<String, dynamic> json) {
    return RelationshipCharacterView(
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

class RelationshipActionView {
  final int actionId;
  final String title;
  final String description;

  RelationshipActionView({
    required this.actionId,
    required this.title,
    required this.description,
  });

    static RelationshipActionView fromJson(Map<String, dynamic> json) {
    return RelationshipActionView(
      actionId: json['actionId'],
      title: json['title'],
      description: json['description'],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'actionId': actionId,
      'title': title,
      'description': description,
    };
  }
}

class RelationshipView {
  final int relationshipId;
  final RelationshipCharacterView fromCharacter;
  final RelationshipCharacterView toCharacter;
  final String description;
  final RelationshipActionView action;

  RelationshipView({
    required this.relationshipId,
    required this.fromCharacter,
    required this.toCharacter,
    required this.description,
    required this.action,
  });

  static RelationshipView fromJson(Map<String, dynamic> json) {
    return RelationshipView(
      relationshipId: json['relationshipId'],
      fromCharacter: RelationshipCharacterView.fromJson(json['fromCharacter']),
      toCharacter: json['toCharacterId'],
      description: json['description'],
      action: json['actionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationshipId': relationshipId,
      'fromCharacter': fromCharacter.toJson(),
      'toCharacter': toCharacter.toJson(),
      'description': description,
      'action': action.toJson(),
    };
  }
}
