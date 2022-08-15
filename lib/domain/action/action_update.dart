class ActionUpdate {
  final int actionId;
  final String? title;
  final String? description;

  const ActionUpdate({
    required this.actionId,
    required this.title,
    required this.description,
  });

  static ActionUpdate fromJson(Map<String, dynamic> json) {
    return ActionUpdate(
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
