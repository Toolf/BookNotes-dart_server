class NoteCreate {
  final int actionId;
  final String content;

  NoteCreate({
    required this.actionId,
    required this.content,
  });

  static NoteCreate fromJson(Map<String, dynamic> json) {
    return NoteCreate(
      actionId: json['actionId'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionId': actionId,
      'content': content,
    };
  }
}
