import '../db/db.dart';
import 'action/action_api.dart';
import 'book/book_api.dart';
import 'character/character_api.dart';
import 'note/note_api.dart';
import 'relationship/relationship_api.dart';
import 'user/user_api.dart';
import 'user_group/user_group_api.dart';

class Api {
  final BookApi book;
  final CharacterApi character;
  final ActionApi action;
  final RelationshipApi relationship;
  final NoteApi note;
  final UserApi user;
  final UserGroupApi userGroup;

  Api._({
    required this.book,
    required this.character,
    required this.action,
    required this.relationship,
    required this.note,
    required this.user,
    required this.userGroup,
  });

  factory Api() {
    return Api._(
      book: BookApi(db),
      character: CharacterApi(db),
      action: ActionApi(db),
      relationship: RelationshipApi(db),
      note: NoteApi(db),
      user: UserApi(db),
      userGroup: UserGroupApi(db),
    );
  }
}

final api = Api();
