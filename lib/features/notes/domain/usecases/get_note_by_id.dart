import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для получения заметки по идентификатору
class GetNoteById {
  final NoteRepository repository;

  GetNoteById(this.repository);

  Future<Either<Failure, Note>> call(NoteParams params) async {
    return await repository.getNoteById(params.id);
  }
}

class NoteParams extends Equatable {
  final int id;

  const NoteParams({required this.id});

  @override
  List<Object> get props => [id];
}
