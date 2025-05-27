import 'package:get_it/get_it.dart';
import 'package:notes_app/features/notes/data/datasources/database.dart';
import 'package:notes_app/features/notes/data/datasources/note_local_data_source.dart';
import 'package:notes_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';
import 'package:notes_app/features/notes/domain/usecases/create_note.dart';
import 'package:notes_app/features/notes/domain/usecases/delete_note.dart';
import 'package:notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:notes_app/features/notes/domain/usecases/get_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/search_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/update_note.dart';

import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/core/theme/theme_cubit.dart';

final sl = GetIt.instance;

/// Инициализация зависимостей
Future<void> init() async {
  // Блоки и кубиты
  
  // Новые кубиты с разделенной логикой
  sl.registerFactory(
    () => NotesListCubit(
      getNotes: sl(),
      searchNotes: sl(),
    ),
  );
  
  sl.registerFactory(
    () => NoteDetailCubit(
      getNoteById: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );
  
  // Кубит темы
  sl.registerFactory(() => ThemeCubit());

  // Use cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => SearchNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Репозитории
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: sl()),
  );

  // Источники данных
  sl.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImpl(database: sl()),
  );

  // База данных
  sl.registerLazySingleton(() => AppDatabase());
}
