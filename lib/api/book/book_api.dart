import '../../core/crudl_api.dart';
import '../../db/db.dart';
import '../../domain/book/book.dart';
import '../../domain/book/book_create.dart';
import '../../domain/book/book_update.dart';
import '../../schema/book/book.dart';
import '../../schema/book/book_create.dart';
import '../../schema/book/book_update.dart';
import 'actions.dart';
import 'characters.dart';

class BookApi {
  final CrudlApi<Book, BookCreate, BookUpdate> _crudl;

  final CharactersEndpoint characters;
  final ActionsEndpoint actions;
  get create => _crudl.create;
  get read => _crudl.read;
  get update => _crudl.update;
  get delete => _crudl.delete;
  get list => _crudl.list;

  BookApi._(
    DB db,
    this.characters,
    this.actions,
  ) : _crudl = CrudlApi<Book, BookCreate, BookUpdate>(
          datasource: db.book,
          entitySchema: bookSchema,
          entityUpdateSchema: bookUpdateSchema,
          entityCreateSchema: bookCreateSchema,
          tags: ["Book"],
        );

  factory BookApi(DB db) {
    return BookApi._(
      db,
      CharactersEndpoint(db),
      ActionsEndpoint(db),
    );
  }
}
