import '../../core/schema/basic_schema.dart';
import '../../core/schema/schema.dart';
import '../../domain/book/book.dart';

final bookSchema = Schema(
  "Book",
  {
    "bookId": BasicSchema(type: "integer"),
    "title": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
    "createAt": BasicSchema(type: "date"),
    "updateAt": BasicSchema(type: "date"),
  },
  (data) => Book.fromJson(data),
);
