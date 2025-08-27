import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_cubit.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_state.dart';
import 'package:notes_app/features/reminders/presentation/pages/reminder_detail_page.dart';
import 'package:notes_app/features/reminders/presentation/widgets/reminder_card.dart';

/// Страница со списком напоминаний
class RemindersListPage extends StatefulWidget {
  /// Показывать ли AppBar
  final bool showAppBar;
  
  /// Конструктор
  const RemindersListPage({super.key, this.showAppBar = true});

  @override
  State<RemindersListPage> createState() => _RemindersListPageState();
}

class _RemindersListPageState extends State<RemindersListPage> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersListCubit>().loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Напоминания'),
            )
          : null,
      body: BlocBuilder<RemindersListCubit, RemindersListState>(
        builder: (context, state) {
          if (state.status == RemindersListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == RemindersListStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage ?? 'Произошла ошибка',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<RemindersListCubit>().loadReminders();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state.reminders.isEmpty) {
            return const Center(
              child: Text('У вас пока нет напоминаний'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<RemindersListCubit>().refreshReminders();
            },
            child: ListView.builder(
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return ReminderCard(
                  reminder: reminder,
                  onTap: () => _navigateToDetailPage(reminder),
                  onDelete: () => _confirmDelete(reminder),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Переход на страницу создания напоминания
  void _navigateToCreatePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ReminderDetailPage(),
      ),
    );
  }

  /// Переход на страницу редактирования напоминания
  void _navigateToDetailPage(Reminder reminder) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReminderDetailPage(reminderId: reminder.id),
      ),
    );
  }

  /// Подтверждение удаления напоминания
  void _confirmDelete(Reminder reminder) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление напоминания'),
        content: Text(
          'Вы действительно хотите удалить напоминание "${reminder.title}" на ${dateFormat.format(reminder.eventDateTime)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (reminder.id != null) {
                context.read<RemindersListCubit>().deleteReminder(reminder.id!);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
