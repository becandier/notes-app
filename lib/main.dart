import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/di/injection_container.dart' as di;
import 'package:notes_app/core/services/onesignal_service.dart';
import 'package:notes_app/core/theme/app_theme.dart';
import 'package:notes_app/core/theme/theme_cubit.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notes_app/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:notes_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminder_detail_cubit.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_cubit.dart';
import 'package:notes_app/firebase_options.dart';

/// Точка входа в приложение
void main() async {
  // Инициализируем Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Инициализируем зависимости
  await di.init();
  
  // Инициализируем OneSignal
  await di.sl<OneSignalService>().initialize();

  // Запускаем приложение
  runApp(const MyApp());
}

/// Корневой виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<NotesListCubit>()),
        BlocProvider(create: (_) => di.sl<NoteDetailCubit>()),
        BlocProvider(create: (_) => di.sl<RemindersListCubit>()),
        BlocProvider(create: (_) => di.sl<ReminderDetailCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Заметки',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
