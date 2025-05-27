import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';

/// UseCase для поиска заметок по запросу
class SearchNotes {
  final NoteRepository repository;

  SearchNotes(this.repository);

  /// Выполняет поиск заметок по запросу
  ///
  /// [params] - параметры поиска
  /// Возвращает Either с ошибкой [Failure] или списком найденных заметок [List<Note>]
  Future<Either<Failure, List<Note>>> call(SearchParams params) async {
    return await repository.searchNotes(params.query);
  }
}

/// Параметры для поиска заметок
class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object> get props => [query];
}
