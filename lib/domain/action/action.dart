class Action {
  const Action({
    required this.actionId,
    required this.title,
    required this.description,
    required this.bookId,
  });
  final int actionId;
  final String title;
  final String description;
  final int bookId;

  static Action fromJson(Map<String, dynamic> json) {
    return Action(
      actionId: json['actionId'],
      bookId: json['bookId'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionId': actionId,
      'bookId': bookId,
      'title': title,
      'description': description,
    };
  }
}
