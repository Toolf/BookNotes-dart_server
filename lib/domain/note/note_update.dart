class NoteUpdate {
  final int noteId;
  final int actionId;
  final String content;

  NoteUpdate({
    required this.noteId,
    required this.actionId,
    required this.content,
  });

  static NoteUpdate fromJson(Map<String, dynamic> json) {
    return NoteUpdate(
      noteId: json['noteId'],
      actionId: json['actionId'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'actionId': actionId,
      'content': content,
    };
  }
}
