import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';

abstract class NoteRepository {
  /// Получить все заметки
  Future<Either<Failure, List<Note>>> getNotes();

  /// Получить заметки с фильтрацией по поисковому запросу
  Future<Either<Failure, List<Note>>> searchNotes(String query);

  /// Получить заметку по идентификатору
  Future<Either<Failure, Note>> getNoteById(int id);

  /// Создать новую заметку
  Future<Either<Failure, Note>> createNote(Note note);

  /// Обновить существующую заметку
  Future<Either<Failure, Note>> updateNote(Note note);

  /// Удалить заметку по идентификатору
  Future<Either<Failure, void>> deleteNote(int id);
}
