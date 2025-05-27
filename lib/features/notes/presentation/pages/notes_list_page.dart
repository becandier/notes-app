import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/theme/theme_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_cubit.dart';
import 'package:notes_app/features/notes/presentation/bloc/notes_list_state.dart';
import 'package:notes_app/features/notes/presentation/pages/note_detail_page.dart';
import 'package:notes_app/features/notes/presentation/widgets/note_card.dart';

/// Страница со списком заметок
class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  // Порядок сортировки заметок
  bool _sortAscending =
      false; // По умолчанию сортируем по убыванию (новые сверху)

  @override
  void initState() {
    super.initState();
    // Загружаем заметки при инициализации страницы
    context.read<NotesListCubit>().loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Поиск заметок...',
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  onChanged: (query) {
                    context.read<NotesListCubit>().searchNotes(query);
                  },
                )
                : const Text('Мои заметки'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  context.read<NotesListCubit>().loadNotes();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                _showThemeDialog();
              } else if (value == 'sort_asc') {
                setState(() {
                  _sortAscending = true;
                });
                _sortNotes();
              } else if (value == 'sort_desc') {
                setState(() {
                  _sortAscending = false;
                });
                _sortNotes();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'sort_asc',
                    child: ListTile(
                      leading: Icon(Icons.arrow_upward),
                      title: Text('Сортировать по дате (старые сверху)'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'sort_desc',
                    child: ListTile(
                      leading: Icon(Icons.arrow_downward),
                      title: Text('Сортировать по дате (новые сверху)'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'theme',
                    child: ListTile(
                      leading: Icon(Icons.brightness_6),
                      title: Text('Сменить тему'),
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: BlocBuilder<NotesListCubit, NotesListState>(
        builder: (context, state) {
          if (state is NotesListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesListLoaded) {
            final notes = state.notes;

            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 80,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.searchQuery != null && state.searchQuery!.isNotEmpty
                          ? 'Заметки не найдены'
                          : 'У вас пока нет заметок',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.searchQuery != null && state.searchQuery!.isNotEmpty
                          ? 'Попробуйте изменить запрос'
                          : 'Нажмите + чтобы создать заметку',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: notes.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                return NoteCard(note: notes[index]);
              },
            );
          } else if (state is NotesListError) {
            return Center(
              child: Text(
                'Ошибка: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteDetailPage()),
          );
        },
        tooltip: 'Добавить заметку',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Сортировка заметок по дате
  void _sortNotes() {
    context.read<NotesListCubit>().sortNotes(ascending: _sortAscending);
  }

  /// Показать диалог выбора темы
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Выберите тему'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_5),
                  title: const Text('Светлая'),
                  onTap: () {
                    context.read<ThemeCubit>().setLightTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_3),
                  title: const Text('Темная'),
                  onTap: () {
                    context.read<ThemeCubit>().setDarkTheme();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brightness_auto),
                  title: const Text('Системная'),
                  onTap: () {
                    context.read<ThemeCubit>().setSystemTheme();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
    );
  }
}
