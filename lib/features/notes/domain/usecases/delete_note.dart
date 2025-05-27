import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для удаления заметки
class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  /// Выполняет удаление заметки по идентификатору
  ///
  /// [params] - параметры с идентификатором заметки
  /// Возвращает Either с ошибкой [Failure] или void при успешном удалении
  Future<Either<Failure, void>> call(NoteParams params) async {
    return await repository.deleteNote(params.id);
  }
}

/// Параметры для удаления заметки
class NoteParams extends Equatable {
  final int id;

  const NoteParams({required this.id});

  @override
  List<Object> get props => [id];
}
