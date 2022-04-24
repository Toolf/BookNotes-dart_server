import '../../core/schema/schema_view.dart';
import '../../domain/book/book_create.dart';
import 'book.dart';

final bookCreateSchema = SchemaView(
  "BookCreate",
  bookSchema,
  [
    SchemaViewField(name: "bookId"),
    SchemaViewField(name: "title"),
    SchemaViewField(name: "description"),
  ],
  (data) => BookCreate.fromJson(data),
);
