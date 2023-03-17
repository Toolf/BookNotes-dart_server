class RelationshipUpdate {
  final int relationshipId;
  final int fromCharacterId;
  final int toCharacterId;
  final String description;
  final int actionId;

  RelationshipUpdate({
    required this.relationshipId,
    required this.fromCharacterId,
    required this.toCharacterId,
    required this.description,
    required this.actionId,
  });

  static RelationshipUpdate fromJson(Map<String, dynamic> json) {
    return RelationshipUpdate(
      relationshipId: json['relationshipId'],
      fromCharacterId: json['fromCharacterId'],
      toCharacterId: json['toCharacterId'],
      description: json['description'],
      actionId: json['actionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relationshipId': relationshipId,
      'fromCharacterId': fromCharacterId,
      'toCharacterId': toCharacterId,
      'description': description,
      'actionId': actionId,
    };
  }
}
