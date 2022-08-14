import '../db/db.dart';
import 'book/book_api.dart';
import 'character/character_api.dart';

class Api {
  final BookApi book;
  final CharacterApi character;

  Api._({
    required this.book,
    required this.character,
  });

  factory Api() {
    return Api._(
      book: BookApi(db.bookDataSource),
      character: CharacterApi(db.characterDataSource),
    );
  }
}

final api = Api();
