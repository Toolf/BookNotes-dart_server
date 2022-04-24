import '../../core/schema/schema_view.dart';
import '../../domain/book/book_update.dart';
import 'book.dart';

final bookUpdateSchema = SchemaView(
  "BookUpdate",
  bookSchema,
  [
    SchemaViewField(name: "bookId"),
    SchemaViewField(name: "title", nullable: true),
    SchemaViewField(name: "description", nullable: true),
  ],
  (data) => BookUpdate.fromJson(data),
);
