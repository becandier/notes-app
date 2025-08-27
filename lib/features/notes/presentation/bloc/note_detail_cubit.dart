import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/usecases/create_note.dart'
    as create;
import 'package:notes_app/features/notes/domain/usecases/delete_note.dart'
    as delete;
import 'package:notes_app/features/notes/domain/usecases/get_note_by_id.dart'
    as get_by_id;
import 'package:notes_app/features/notes/domain/usecases/update_note.dart'
    as update;
import 'package:notes_app/features/notes/presentation/bloc/note_detail_state.dart';

/// Кубит для управления отдельной заметкой
class NoteDetailCubit extends Cubit<NoteDetailState> {
  final get_by_id.GetNoteById _getNoteById;
  final create.CreateNote _createNote;
  final update.UpdateNote _updateNote;
  final delete.DeleteNote _deleteNote;

  NoteDetailCubit({
    required get_by_id.GetNoteById getNoteById,
    required create.CreateNote createNote,
    required update.UpdateNote updateNote,
    required delete.DeleteNote deleteNote,
  }) : _getNoteById = getNoteById,
       _createNote = createNote,
       _updateNote = updateNote,
       _deleteNote = deleteNote,
       super(const NoteDetailInitial());

  Future<void> getNoteById(int id) async {
    emit(const NoteDetailLoading());

    final result = await _getNoteById(get_by_id.NoteParams(id: id));

    result.fold(
      (failure) => emit(NoteDetailError(message: failure.message)),
      (note) => emit(
        NoteActionCompleted(
          isSuccess: true,
          note: note,
          action: NoteAction.load,
        ),
      ),
    );
  }

  Future<void> createNote(Note note) async {
    emit(const NoteDetailLoading());

    final result = await _createNote(create.NoteParams(note: note));

    result.fold(
      (failure) => emit(
        NoteActionCompleted(
          isSuccess: false,
          message: failure.message,
          action: NoteAction.create,
        ),
      ),
      (createdNote) {
        emit(
          NoteActionCompleted(
            isSuccess: true,
            note: createdNote,
            message: 'Заметка успешно создана',
            action: NoteAction.create,
          ),
        );
      },
    );
  }

  Future<void> updateNote(Note note) async {
    emit(const NoteDetailLoading());

    final result = await _updateNote(update.NoteParams(note: note));

    result.fold(
      (failure) => emit(
        NoteActionCompleted(
          isSuccess: false,
          message: failure.message,
          action: NoteAction.update,
        ),
      ),
      (updatedNote) {
        emit(
          NoteActionCompleted(
            isSuccess: true,
            note: updatedNote,
            message: 'Заметка успешно обновлена',
            action: NoteAction.update,
          ),
        );
      },
    );
  }

  Future<void> deleteNote(int id) async {
    emit(const NoteDetailLoading());

    final result = await _deleteNote(delete.NoteParams(id: id));

    result.fold(
      (failure) => emit(
        NoteActionCompleted(
          isSuccess: false,
          message: failure.message,
          action: NoteAction.delete,
        ),
      ),
      (_) {
        emit(
          const NoteActionCompleted(
            isSuccess: true,
            message: 'Заметка успешно удалена',
            action: NoteAction.delete,
          ),
        );
      },
    );
  }
}
