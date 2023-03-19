class Note {
  final int noteId;
  final int actionId;
  final String text;

  Note({
    required this.noteId,
    required this.actionId,
    required this.text,
  });

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json['noteId'],
      actionId: json['actionId'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'actionId': actionId,
      'text': text,
    };
  }
}
