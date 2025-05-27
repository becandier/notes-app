import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для обновления существующей заметки
class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  /// Выполняет обновление существующей заметки
  ///
  /// [params] - параметры с данными заметки
  /// Возвращает Either с ошибкой [Failure] или обновленную заметку [Note]
  Future<Either<Failure, Note>> call(NoteParams params) async {
    // Проверка валидности заголовка
    if (params.note.title.isEmpty) {
      return Left(const ValidationFailure(message: 'Заголовок не может быть пустым'));
    }
    
    // Проверка наличия идентификатора
    if (params.note.id == null) {
      return Left(const ValidationFailure(message: 'Идентификатор заметки не может быть пустым'));
    }
    
    return await repository.updateNote(params.note);
  }
}

/// Параметры для обновления заметки
class NoteParams extends Equatable {
  final Note note;

  const NoteParams({required this.note});

  @override
  List<Object> get props => [note];
}
