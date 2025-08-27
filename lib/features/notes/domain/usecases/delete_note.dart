import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для удаления заметки
class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<Either<Failure, void>> call(NoteParams params) async {
    return await repository.deleteNote(params.id);
  }
}

class NoteParams extends Equatable {
  final int id;

  const NoteParams({required this.id});

  @override
  List<Object> get props => [id];
}
