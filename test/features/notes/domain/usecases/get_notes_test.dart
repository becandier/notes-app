import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';
import 'package:notes_app/features/notes/domain/usecases/get_notes.dart';

import 'get_notes_test.mocks.dart';

@GenerateMocks([NoteRepository])
void main() {
  late GetNotes usecase;
  late MockNoteRepository mockNoteRepository;

  setUp(() {
    mockNoteRepository = MockNoteRepository();
    usecase = GetNotes(mockNoteRepository);
  });

  final testNotes = [
    Note(
      id: 1,
      title: 'Тестовая заметка 1',
      content: 'Содержание тестовой заметки 1',
      createdAt: DateTime(2025, 5, 1, 10, 0),
    ),
    Note(
      id: 2,
      title: 'Тестовая заметка 2',
      content: 'Содержание тестовой заметки 2',
      createdAt: DateTime(2025, 5, 2, 11, 0),
    ),
  ];

  test('должен получить список заметок из репозитория', () async {
    // arrange
    when(mockNoteRepository.getNotes())
        .thenAnswer((_) async => Right(testNotes));

    // act
    final result = await usecase();

    // assert
    expect(result, Right(testNotes));
    verify(mockNoteRepository.getNotes());
    verifyNoMoreInteractions(mockNoteRepository);
  });
}
