part of 'server.dart';

final endpoints = <String, Endpoint>{
  // Auth
  "auth/login": api.auth.login,
  "auth/refresh": api.auth.refresh,
  "auth/registry": api.auth.registry,
  // Book
  "book/list": api.book.list,
  "book/create": api.book.create,
  "book/read": api.book.read,
  "book/update": api.book.update,
  "book/delete": api.book.delete,
  "book/characters": api.book.characters,
  "book/actions": api.book.actions,
  // Character
  "character/create": api.character.create,
  "character/read": api.character.read,
  "character/update": api.character.update,
  "character/delete": api.character.delete,
  "character/list": api.character.list,
  // Action
  "action/create": api.action.create,
  "action/read": api.action.read,
  "action/update": api.action.update,
  "action/delete": api.action.delete,
  "action/list": api.action.list,
};
