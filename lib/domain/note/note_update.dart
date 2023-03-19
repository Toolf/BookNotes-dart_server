class NoteUpdate {
  final int noteId;
  final int actionId;
  final String text;

  NoteUpdate({
    required this.noteId,
    required this.actionId,
    required this.text,
  });

  static NoteUpdate fromJson(Map<String, dynamic> json) {
    return NoteUpdate(
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
