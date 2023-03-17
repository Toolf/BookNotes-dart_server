class RelationshipCreate {
  final int fromCharacterId;
  final int toCharacterId;
  final String description;
  final int actionId;

  RelationshipCreate({
    required this.fromCharacterId,
    required this.toCharacterId,
    required this.description,
    required this.actionId,
  });

  static RelationshipCreate fromJson(Map<String, dynamic> json) {
    return RelationshipCreate(
      fromCharacterId: json['fromCharacterId'],
      toCharacterId: json['toCharacterId'],
      description: json['description'],
      actionId: json['actionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromCharacterId': fromCharacterId,
      'toCharacterId': toCharacterId,
      'description': description,
      'actionId': actionId,
    };
  }
}
