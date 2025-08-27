import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для создания новой заметки
class CreateNote {
  final NoteRepository repository;

  CreateNote(this.repository);

  Future<Either<Failure, Note>> call(NoteParams params) async {
    if (params.note.title.isEmpty) {
      return Left(
        const ValidationFailure(message: 'Заголовок не может быть пустым'),
      );
    }

    return await repository.createNote(params.note);
  }
}

class NoteParams extends Equatable {
  final Note note;

  const NoteParams({required this.note});

  @override
  List<Object> get props => [note];
}
