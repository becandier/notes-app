import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/di/injection_container.dart' as di;
import 'package:notes_app/core/theme/app_theme.dart';
import 'package:notes_app/core/theme/theme_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/note_detail_cubit.dart';
import 'package:notes_app/features/notes/presentation/pages/notes_list_page.dart';

/// Точка входа в приложение
void main() async {
  // Инициализируем Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем зависимости
  await di.init();
  
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
        BlocProvider(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider(
          create: (_) => di.sl<NotesListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<NoteDetailCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Заметки',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const NotesListPage(),
          );
        },
      ),
    );
  }
}
