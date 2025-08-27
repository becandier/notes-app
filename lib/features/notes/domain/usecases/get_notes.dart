import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

class GetNotes {
  final NoteRepository repository;

  GetNotes(this.repository);

  Future<Either<Failure, List<Note>>> call() async {
    return await repository.getNotes();
  }
}
