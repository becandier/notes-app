import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/usecases/create_note.dart' as create;
import 'package:notes_app/features/notes/domain/usecases/delete_note.dart' as delete;
import 'package:notes_app/features/notes/domain/usecases/get_note_by_id.dart' as get_by_id;
import 'package:notes_app/features/notes/domain/usecases/update_note.dart' as update;
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_state.dart';

import 'note_detail_cubit_test.mocks.dart';

@GenerateMocks([
  get_by_id.GetNoteById,
  create.CreateNote,
  update.UpdateNote,
  delete.DeleteNote,
])
void main() {
  late NoteDetailCubit noteDetailCubit;
  late MockGetNoteById mockGetNoteById;
  late MockCreateNote mockCreateNote;
  late MockUpdateNote mockUpdateNote;
  late MockDeleteNote mockDeleteNote;

  setUp(() {
    mockGetNoteById = MockGetNoteById();
    mockCreateNote = MockCreateNote();
    mockUpdateNote = MockUpdateNote();
    mockDeleteNote = MockDeleteNote();

    noteDetailCubit = NoteDetailCubit(
      getNoteById: mockGetNoteById,
      createNote: mockCreateNote,
      updateNote: mockUpdateNote,
      deleteNote: mockDeleteNote,
    );
  });

  final testNote = Note(
    id: 1,
    title: 'Тестовая заметка',
    content: 'Содержание тестовой заметки',
    createdAt: DateTime(2025, 5, 1, 10, 0),
  );

  test('начальное состояние должно быть NoteDetailInitial', () {
    // assert
    expect(noteDetailCubit.state, const NoteDetailInitial());
  });

  group('getNoteById', () {
    test('должен эмитировать [NoteDetailLoading, NoteActionCompleted] при успешной загрузке заметки', () async {
      // arrange
      final noteParams = get_by_id.NoteParams(id: 1);
      when(mockGetNoteById(noteParams)).thenAnswer((_) async => Right(testNote));

      // assert later
      final expected = [
        const NoteDetailLoading(),
        NoteActionCompleted(
          isSuccess: true,
          note: testNote,
          action: NoteAction.load,
        ),
      ];
      expectLater(noteDetailCubit.stream, emitsInOrder(expected));

      // act
      await noteDetailCubit.getNoteById(1);
    });

    test('должен эмитировать [NoteDetailLoading, NoteDetailError] при ошибке загрузки заметки', () async {
      // arrange
      final noteParams = get_by_id.NoteParams(id: 1);
      final failure = DatabaseFailure(message: 'Ошибка загрузки заметки');
      when(mockGetNoteById(noteParams)).thenAnswer((_) async => Left(failure));

      // assert later
      final expected = [
        const NoteDetailLoading(),
        NoteDetailError(message: failure.message),
      ];
      expectLater(noteDetailCubit.stream, emitsInOrder(expected));

      // act
      await noteDetailCubit.getNoteById(1);
    });
  });

  group('createNote', () {
    test('должен эмитировать [NoteDetailLoading, NoteActionCompleted] при успешном создании заметки', () async {
      // arrange
      final noteParams = create.NoteParams(note: testNote);
      when(mockCreateNote(noteParams)).thenAnswer((_) async => Right(testNote));

      // assert later
      final expected = [
        const NoteDetailLoading(),
        NoteActionCompleted(
          isSuccess: true,
          note: testNote,
          message: 'Заметка успешно создана',
          action: NoteAction.create,
        ),
      ];
      expectLater(noteDetailCubit.stream, emitsInOrder(expected));

      // act
      await noteDetailCubit.createNote(testNote);
    });
  });

  group('updateNote', () {
    test('должен эмитировать [NoteDetailLoading, NoteActionCompleted] при успешном обновлении заметки', () async {
      // arrange
      final noteParams = update.NoteParams(note: testNote);
      when(mockUpdateNote(noteParams)).thenAnswer((_) async => Right(testNote));

      // assert later
      final expected = [
        const NoteDetailLoading(),
        NoteActionCompleted(
          isSuccess: true,
          note: testNote,
          message: 'Заметка успешно обновлена',
          action: NoteAction.update,
        ),
      ];
      expectLater(noteDetailCubit.stream, emitsInOrder(expected));

      // act
      await noteDetailCubit.updateNote(testNote);
    });
  });

  group('deleteNote', () {
    test('должен эмитировать [NoteDetailLoading, NoteActionCompleted] при успешном удалении заметки', () async {
      // arrange
      final noteParams = delete.NoteParams(id: 1);
      when(mockDeleteNote(noteParams)).thenAnswer((_) async => const Right(null));

      // assert later
      final expected = [
        const NoteDetailLoading(),
        const NoteActionCompleted(
          isSuccess: true,
          message: 'Заметка успешно удалена',
          action: NoteAction.delete,
        ),
      ];
      expectLater(noteDetailCubit.stream, emitsInOrder(expected));

      // act
      await noteDetailCubit.deleteNote(1);
    });
  });
}
