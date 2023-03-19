class Note {
  final int noteId;
  final int actionId;
  final String content;

  Note({
    required this.noteId,
    required this.actionId,
    required this.content,
  });

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
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
