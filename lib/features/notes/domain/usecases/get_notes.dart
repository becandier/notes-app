import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для получения всех заметок
class GetNotes {
  final NoteRepository repository;

  GetNotes(this.repository);

  /// Выполняет получение всех заметок
  ///
  /// Возвращает Either с ошибкой [Failure] или списком заметок [List<Note>]
  Future<Either<Failure, List<Note>>> call() async {
    return await repository.getNotes();
  }
}
