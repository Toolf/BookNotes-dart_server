part of 'server.dart';

final endpoints = <String, Endpoint>{
  // Book
  "book/list": api.book.list,
  "book/create": api.book.create,
  "book/read": api.book.read,
  "book/update": api.book.update,
  "book/delete": api.book.delete,
  "book/characters": api.book.characters,
  // Character
  "character/create": api.character.create,
  "character/read": api.character.read,
  "character/update": api.character.update,
  "character/delete": api.character.delete,
  "character/list": api.character.list,
};
