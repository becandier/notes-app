import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/usecases/get_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/search_notes.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_state.dart';

class NotesListCubit extends Cubit<NotesListState> {
  final GetNotes _getNotes;
  final SearchNotes _searchNotes;

  NotesListCubit({required GetNotes getNotes, required SearchNotes searchNotes})
    : _getNotes = getNotes,
      _searchNotes = searchNotes,
      super(const NotesListInitial());

  Future<void> loadNotes() async {
    emit(const NotesListLoading());

    final result = await _getNotes();

    result.fold(
      (failure) => emit(NotesListError(message: failure.message)),
      (notes) => emit(NotesListLoaded(notes: notes)),
    );
  }

  Future<void> searchNotes(String query) async {
    emit(const NotesListLoading());

    if (query.isEmpty) {
      await loadNotes();
      return;
    }

    final result = await _searchNotes(SearchParams(query: query));

    result.fold(
      (failure) => emit(NotesListError(message: failure.message)),
      (notes) => emit(NotesListLoaded(notes: notes, searchQuery: query)),
    );
  }

  void sortNotes({required bool ascending}) {
    if (state is NotesListLoaded) {
      final currentState = state as NotesListLoaded;
      final notes = List<Note>.from(currentState.notes);

      // Сортируем заметки по дате
      notes.sort(
        (a, b) =>
            ascending
                ? a.createdAt.compareTo(b.createdAt)
                : b.createdAt.compareTo(a.createdAt),
      );

      emit(
        NotesListLoaded(notes: notes, searchQuery: currentState.searchQuery),
      );
    }
  }

  void refreshNotes() {
    loadNotes();
  }
}
