import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notes_app/features/home/presentation/bloc/home_cubit.dart';
import 'package:notes_app/features/home/presentation/bloc/home_state.dart';
import 'package:notes_app/features/notes/presentation/pages/notes_list_page.dart';
import 'package:notes_app/features/reminders/presentation/pages/reminders_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<HomeCubit>().changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (_tabController.index != state.tabIndex) {
            _tabController.animateTo(state.tabIndex);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Мои записи'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _confirmLogout,
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.note), text: 'Заметки'),
                  Tab(icon: Icon(Icons.alarm), text: 'Напоминания'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: const [
                NotesListPage(showAppBar: false),
                RemindersListPage(showAppBar: false),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Подтверждение выхода из аккаунта
  void _confirmLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Выход из аккаунта'),
            content: const Text('Вы действительно хотите выйти из аккаунта?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().signOut();
                },
                child: const Text('Выйти'),
              ),
            ],
          ),
    );
  }
}
