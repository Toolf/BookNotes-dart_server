import '../../core/endpoint.dart';
import '../../core/pagination/pagination.dart';
import '../../core/pagination/pagination_schema.dart';
import '../../db/db.dart';
import '../../domain/action/note_pagination_request.dart';
import '../../domain/note/note.dart';
import '../../schema/action/note_pagination_request.dart';
import '../../schema/note/note.dart';

class NotesEndpoint
    extends Endpoint<NotePaginationRequest, PaginationResponse<Note>> {
  final DB db;

  NotesEndpoint(this.db);

  @override
  get parameters => notePaginationRequestSchema;
  @override
  get returns => PaginationResponseSchema(noteSchema);
  @override
  get tags => ["Action"];

  @override
  Future<PaginationResponse<Note>> method(
    NotePaginationRequest request,
  ) async {
    final notes = await db.action.notes(request);
    return notes;
  }

  @override
  void validate(PaginationRequest request) {}
}
