import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/usecases/get_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/search_notes.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_state.dart';

import 'notes_list_cubit_test.mocks.dart';

@GenerateMocks([
  GetNotes,
  SearchNotes,
])
void main() {
  late NotesListCubit notesListCubit;
  late MockGetNotes mockGetNotes;
  late MockSearchNotes mockSearchNotes;

  setUp(() {
    mockGetNotes = MockGetNotes();
    mockSearchNotes = MockSearchNotes();

    notesListCubit = NotesListCubit(
      getNotes: mockGetNotes,
      searchNotes: mockSearchNotes,
    );
  });

  final testNotes = [
    Note(
      id: 1,
      title: 'Старая заметка',
      content: 'Содержание старой заметки',
      createdAt: DateTime(2025, 5, 1, 10, 0),
    ),
    Note(
      id: 2,
      title: 'Новая заметка',
      content: 'Содержание новой заметки',
      createdAt: DateTime(2025, 5, 2, 11, 0),
    ),
  ];

  test('начальное состояние должно быть NotesListInitial', () {
    // assert
    expect(notesListCubit.state, const NotesListInitial());
  });

  group('loadNotes', () {
    test('должен эмитировать [NotesListLoading, NotesListLoaded] при успешной загрузке заметок', () async {
      // arrange
      when(mockGetNotes()).thenAnswer((_) async => Right(testNotes));

      // assert later
      final expected = [
        const NotesListLoading(),
        NotesListLoaded(notes: testNotes),
      ];
      expectLater(notesListCubit.stream, emitsInOrder(expected));

      // act
      await notesListCubit.loadNotes();
    });
  });

  group('searchNotes', () {
    test('должен вызвать loadNotes, если запрос пустой', () async {
      // arrange
      when(mockGetNotes()).thenAnswer((_) async => Right(testNotes));

      // act
      await notesListCubit.searchNotes('');

      // assert
      verify(mockGetNotes()).called(1);
    });

    test('должен эмитировать [NotesListLoading, NotesListLoaded] при успешном поиске заметок', () async {
      // arrange
      final query = 'Новая';
      final searchParams = SearchParams(query: query);
      when(mockSearchNotes(searchParams)).thenAnswer((_) async => Right([testNotes[1]]));

      // assert later
      final expected = [
        const NotesListLoading(),
        NotesListLoaded(notes: [testNotes[1]], searchQuery: query),
      ];
      expectLater(notesListCubit.stream, emitsInOrder(expected));

      // act
      await notesListCubit.searchNotes(query);
    });
  });

  test('должен сортировать заметки по возрастанию даты', () {
    // arrange
    final loadedState = NotesListLoaded(notes: testNotes);
    notesListCubit.emit(loadedState);

    // act
    notesListCubit.sortNotes(ascending: true);

    // assert
    final currentState = notesListCubit.state as NotesListLoaded;
    expect(currentState.notes.first.id, 1);
    expect(currentState.notes.last.id, 2);
  });

  test('должен сортировать заметки по убыванию даты', () {
    // arrange
    final loadedState = NotesListLoaded(notes: testNotes);
    notesListCubit.emit(loadedState);

    // act
    notesListCubit.sortNotes(ascending: false);

    // assert
    final currentState = notesListCubit.state as NotesListLoaded;
    expect(currentState.notes.first.id, 2);
    expect(currentState.notes.last.id, 1);
  });
}
