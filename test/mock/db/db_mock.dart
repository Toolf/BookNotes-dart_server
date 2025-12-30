import 'package:book_notes/db/action_datasource.dart';
import 'package:book_notes/db/book_datasource.dart';
import 'package:book_notes/db/character_datasource.dart';
import 'package:book_notes/db/note_datasource.dart';
import 'package:book_notes/db/relationship_datasource.dart';
import 'package:book_notes/db/user_datasource.dart';
import 'package:book_notes/db/user_group_datasource.dart';
import 'package:mocktail/mocktail.dart';


class UserDataSourceMock extends Mock implements UserDataSource {}
class UserGroupDataSourceMock extends Mock implements UserGroupDataSource {}
class BookDataSourceMock extends Mock implements BookDataSource {}
class CharacterDataSourceMock extends Mock implements CharacterDataSource {}
class ActionDataSourceMock extends Mock implements ActionDataSource {}
class RelationshipDataSourceMock extends Mock implements RelationshipDataSource {}
class NoteDataSourceMock extends Mock implements NoteDataSource {}