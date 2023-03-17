import '../db/db.dart';
import 'action/action_api.dart';
import 'auth/auth_api.dart';
import 'book/book_api.dart';
import 'character/character_api.dart';

class Api {
  final BookApi book;
  final CharacterApi character;
  final ActionApi action;
  final AuthApi auth;

  Api._({
    required this.book,
    required this.character,
    required this.action,
    required this.auth,
  });

  factory Api() {
    return Api._(
      book: BookApi(db.bookDataSource),
      character: CharacterApi(db.characterDataSource),
      action: ActionApi(db.actionDataSource),
      auth: AuthApi(),
    );
  }
}

final api = Api();
