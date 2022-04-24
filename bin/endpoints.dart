part of 'server.dart';

final endpoints = <String, Endpoint>{
  "book/list": api.book.list,
  "book/create": api.book.create,
  "book/read": api.book.read,
  "book/update": api.book.update,
  "book/delete": api.book.delete,
};
