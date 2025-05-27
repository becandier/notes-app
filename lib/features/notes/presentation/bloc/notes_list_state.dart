import 'package:equatable/equatable.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';

/// Базовое состояние для списка заметок
abstract class NotesListState extends Equatable {
  const NotesListState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class NotesListInitial extends NotesListState {
  const NotesListInitial();
}

/// Состояние загрузки
class NotesListLoading extends NotesListState {
  const NotesListLoading();
}

/// Состояние успешной загрузки заметок
class NotesListLoaded extends NotesListState {
  final List<Note> notes;
  final String? searchQuery;

  const NotesListLoaded({
    required this.notes,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [notes, searchQuery];
}

/// Состояние ошибки
class NotesListError extends NotesListState {
  final String message;

  const NotesListError({required this.message});

  @override
  List<Object> get props => [message];
}
