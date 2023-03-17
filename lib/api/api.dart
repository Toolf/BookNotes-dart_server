import '../db/db.dart';
import 'action/action_api.dart';
import 'book/book_api.dart';
import 'character/character_api.dart';
import 'relationship/relationship_api.dart';

class Api {
  final BookApi book;
  final CharacterApi character;
  final ActionApi action;
  final RelationshipApi relationship;

  Api._({
    required this.book,
    required this.character,
    required this.action,
    required this.relationship,
  });

  factory Api() {
    return Api._(
      book: BookApi(db.bookDataSource),
      character: CharacterApi(db.characterDataSource),
      action: ActionApi(db.actionDataSource),
      relationship: RelationshipApi(db.relationshipDataSource),
    );
  }
}

final api = Api();
