class NoteCreate {
  final int actionId;
  final String text;

  NoteCreate({
    required this.actionId,
    required this.text,
  });

  static NoteCreate fromJson(Map<String, dynamic> json) {
    return NoteCreate(
      actionId: json['actionId'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actionId': actionId,
      'text': text,
    };
  }
}
