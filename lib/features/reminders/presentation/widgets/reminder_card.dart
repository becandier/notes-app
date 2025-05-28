import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';

/// Виджет карточки напоминания
class ReminderCard extends StatelessWidget {
  /// Напоминание
  final Reminder reminder;
  
  /// Обработчик нажатия
  final VoidCallback onTap;
  
  /// Обработчик удаления
  final VoidCallback onDelete;
  
  /// Конструктор
  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
    required this.onDelete,
  });
  
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    
    return Dismissible(
      key: Key('reminder_${reminder.id}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Подтверждение'),
              content: const Text('Вы уверены, что хотите удалить это напоминание?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Удалить'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListTile(
          title: Text(
            reminder.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.event, size: 16),
                  const SizedBox(width: 4),
                  Text('Событие: ${dateFormat.format(reminder.eventDateTime)}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.notifications, size: 16),
                  const SizedBox(width: 4),
                  Text('Уведомление: ${dateFormat.format(reminder.notificationDateTime)}'),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
