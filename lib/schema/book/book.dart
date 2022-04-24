import '../../core/schema/basic_shema.dart';
import '../../core/schema/schema.dart';
import '../../domain/book/book.dart';

final bookSchema = Schema(
  "Book",
  {
    "bookId": BasicSchema(type: "integer"),
    "title": BasicSchema(type: "string", lengthMax: 64, lengthMin: 1),
    "description": BasicSchema(type: "string"),
  },
  (data) => Book.fromJson(data),
);
