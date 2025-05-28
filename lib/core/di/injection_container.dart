import 'package:get_it/get_it.dart';
import 'package:notes_app/core/services/auth_service.dart';
import 'package:notes_app/core/services/onesignal_service.dart';
import 'package:notes_app/core/services/supabase_service.dart';
import 'package:notes_app/core/theme/theme_cubit.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notes_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:notes_app/features/notes/data/datasources/note_remote_data_source.dart';
import 'package:notes_app/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes_app/features/notes/domain/repositories/note_repository.dart';
import 'package:notes_app/features/notes/domain/usecases/create_note.dart';
import 'package:notes_app/features/notes/domain/usecases/delete_note.dart';
import 'package:notes_app/features/notes/domain/usecases/get_note_by_id.dart';
import 'package:notes_app/features/notes/domain/usecases/get_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/search_notes.dart';
import 'package:notes_app/features/notes/domain/usecases/update_note.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
// Импорты для модуля напоминаний
import 'package:notes_app/features/reminders/data/datasources/reminder_remote_data_source.dart';
import 'package:notes_app/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:notes_app/features/reminders/domain/usecases/create_reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/delete_reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/get_reminder_by_id.dart';
import 'package:notes_app/features/reminders/domain/usecases/get_reminders.dart';
import 'package:notes_app/features/reminders/domain/usecases/update_reminder.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminder_detail_cubit.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_cubit.dart';

final sl = GetIt.instance;

/// Инициализация зависимостей
Future<void> init() async {
  // Инициализация Supabase
  await SupabaseService.initialize();

  // Сервисы
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
  sl.registerLazySingleton<OneSignalService>(
    () => OneSignalService(),
  );

  // Основные кубиты
  sl.registerFactory(() => AuthCubit(authService: sl<AuthService>()));
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => HomeCubit());

  // Notes
  // Data sources
  sl.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => SearchNotes(sl()));

  // Blocs
  sl.registerFactory(() => NotesListCubit(getNotes: sl(), searchNotes: sl()));
  sl.registerFactory(
    () => NoteDetailCubit(
      getNoteById: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );

  // Reminders
  // Data sources
  sl.registerLazySingleton<ReminderRemoteDataSource>(
    () => ReminderRemoteDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetReminders(sl()));
  sl.registerLazySingleton(() => GetReminderById(sl()));
  sl.registerLazySingleton(() => CreateReminder(sl()));
  sl.registerLazySingleton(() => UpdateReminder(sl()));
  sl.registerLazySingleton(() => DeleteReminder(sl()));

  // Blocs
  sl.registerFactory(
    () => RemindersListCubit(
      authService: sl(),
      getReminders: sl(),
      createReminder: sl(),
      deleteReminder: sl(),
    ),
  );
  sl.registerFactory(
    () => ReminderDetailCubit(getReminderById: sl(), updateReminder: sl()),
  );
}
