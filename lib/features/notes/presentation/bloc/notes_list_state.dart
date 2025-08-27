import 'package:equatable/equatable.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';

abstract class NotesListState extends Equatable {
  const NotesListState();

  @override
  List<Object?> get props => [];
}

class NotesListInitial extends NotesListState {
  const NotesListInitial();
}

class NotesListLoading extends NotesListState {
  const NotesListLoading();
}

class NotesListLoaded extends NotesListState {
  final List<Note> notes;
  final String? searchQuery;

  const NotesListLoaded({required this.notes, this.searchQuery});

  @override
  List<Object?> get props => [notes, searchQuery];
}

class NotesListError extends NotesListState {
  final String message;

  const NotesListError({required this.message});

  @override
  List<Object> get props => [message];
}
