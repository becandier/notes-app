import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminder_detail_cubit.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminder_detail_state.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_cubit.dart';

/// Страница создания/редактирования напоминания
class ReminderDetailPage extends StatefulWidget {
  /// ID напоминания (null для создания нового)
  final String? reminderId;

  /// Конструктор
  const ReminderDetailPage({super.key, this.reminderId});

  @override
  State<ReminderDetailPage> createState() => _ReminderDetailPageState();
}

class _ReminderDetailPageState extends State<ReminderDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  DateTime _eventDateTime = DateTime.now().add(const Duration(hours: 1));
  ReminderType _reminderType = ReminderType.exact;

  @override
  void initState() {
    super.initState();
    if (widget.reminderId != null) {
      context.read<ReminderDetailCubit>().loadReminder(widget.reminderId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminderId == null ? 'Новое напоминание' : 'Редактирование напоминания'),
      ),
      body: BlocConsumer<ReminderDetailCubit, ReminderDetailState>(
        listener: (context, state) {
          if (state.status == ReminderDetailStatus.loaded && state.reminder != null) {
            _titleController.text = state.reminder!.title;
            _eventDateTime = state.reminder!.eventDateTime;
            _reminderType = state.reminder!.reminderType;
          } else if (state.status == ReminderDetailStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Произошла ошибка'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ReminderDetailStatus.loading && widget.reminderId != null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите название';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Дата и время события',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildDateTimePicker(),
                  const SizedBox(height: 16),
                  const Text(
                    'Тип напоминания',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildReminderTypeSelector(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveReminder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.reminderId == null ? 'Создать напоминание' : 'Сохранить изменения',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Виджет выбора даты и времени
  Widget _buildDateTimePicker() {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    
    return InkWell(
      onTap: _pickDateTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 8),
            Text(dateFormat.format(_eventDateTime)),
          ],
        ),
      ),
    );
  }

  /// Виджет выбора типа напоминания
  Widget _buildReminderTypeSelector() {
    return DropdownButtonFormField<ReminderType>(
      value: _reminderType,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(
          value: ReminderType.exact,
          child: const Text('В точное время события'),
        ),
        DropdownMenuItem(
          value: ReminderType.fiveMinutes,
          child: const Text('За 5 минут до события'),
        ),
        DropdownMenuItem(
          value: ReminderType.tenMinutes,
          child: const Text('За 10 минут до события'),
        ),
        DropdownMenuItem(
          value: ReminderType.fifteenMinutes,
          child: const Text('За 15 минут до события'),
        ),
        DropdownMenuItem(
          value: ReminderType.thirtyMinutes,
          child: const Text('За 30 минут до события'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _reminderType = value;
          });
        }
      },
    );
  }

  /// Выбор даты и времени
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _eventDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date == null) return;
    
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_eventDateTime),
    );
    
    if (time == null) return;
    
    setState(() {
      _eventDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  /// Сохранение напоминания
  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      final currentUser = context.read<RemindersListCubit>().currentUser;
      
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пользователь не авторизован'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (widget.reminderId == null) {
        // Создание нового напоминания
        final reminder = Reminder(
          title: _titleController.text,
          eventDateTime: _eventDateTime,
          notificationDateTime: Reminder.calculateNotificationTime(_eventDateTime, _reminderType),
          reminderType: _reminderType,
          userId: currentUser.id,
        );
        
        context.read<RemindersListCubit>().createReminder(reminder);
      } else {
        // Обновление существующего напоминания
        final reminder = Reminder(
          id: widget.reminderId,
          title: _titleController.text,
          eventDateTime: _eventDateTime,
          notificationDateTime: Reminder.calculateNotificationTime(_eventDateTime, _reminderType),
          reminderType: _reminderType,
          userId: currentUser.id,
        );
        
        context.read<ReminderDetailCubit>().updateReminder(reminder);
      }
      
      Navigator.of(context).pop();
    }
  }
}
