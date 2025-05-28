import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/core/services/supabase_service.dart';
import 'package:notes_app/features/reminders/data/models/reminder_model.dart';
import 'package:uuid/uuid.dart';

/// Интерфейс удаленного источника данных для напоминаний
abstract class ReminderRemoteDataSource {
  /// Получить все напоминания пользователя
  Future<List<ReminderModel>> getReminders();

  /// Получить напоминание по ID
  Future<ReminderModel> getReminderById(String id);

  /// Создать новое напоминание
  Future<ReminderModel> createReminder(ReminderModel reminder);

  /// Обновить напоминание
  Future<ReminderModel> updateReminder(ReminderModel reminder);

  /// Удалить напоминание
  Future<void> deleteReminder(String id);

  /// Запланировать уведомление для напоминания
  Future<void> scheduleNotification(ReminderModel reminder);
}

/// Реализация удаленного источника данных для напоминаний
class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  /// Название таблицы в Supabase
  static const String _tableName = 'reminders';

  /// Получить все напоминания пользователя
  @override
  Future<List<ReminderModel>> getReminders() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      final response = await SupabaseService.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('event_datetime', ascending: true);

      return (response as List<dynamic>)
          .map((json) => ReminderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при получении напоминаний: ${e.toString()}',
      );
    }
  }

  /// Получить напоминание по ID
  @override
  Future<ReminderModel> getReminderById(String id) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      final response =
          await SupabaseService.client
              .from(_tableName)
              .select()
              .eq('id', id)
              .eq('user_id', userId)
              .single();

      return ReminderModel.fromJson(response);
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при получении напоминания: ${e.toString()}',
      );
    }
  }

  /// Создать новое напоминание
  @override
  Future<ReminderModel> createReminder(ReminderModel reminder) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      // Создаем уникальный ID для напоминания
      final newReminder = reminder.copyWith(
        id: const Uuid().v4(),
        userId: userId,
      );

      final response =
          await SupabaseService.client
              .from(_tableName)
              .insert(newReminder.toJson())
              .select()
              .single();

      final createdReminder = ReminderModel.fromJson(response);

      // Планируем уведомление
      await scheduleNotification(createdReminder);

      return createdReminder;
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при создании напоминания: ${e.toString()}',
      );
    }
  }

  /// Обновить напоминание
  @override
  Future<ReminderModel> updateReminder(ReminderModel reminder) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      if (reminder.id == null) {
        throw DatabaseException(message: 'ID напоминания не может быть пустым');
      }

      final response =
          await SupabaseService.client
              .from(_tableName)
              .update(reminder.toJson())
              .eq('id', reminder.id!)
              .eq('user_id', userId)
              .select()
              .single();

      final updatedReminder = ReminderModel.fromJson(response);

      // Обновляем уведомление
      await scheduleNotification(updatedReminder);

      return updatedReminder;
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при обновлении напоминания: ${e.toString()}',
      );
    }
  }

  /// Удалить напоминание
  @override
  Future<void> deleteReminder(String id) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      await SupabaseService.client
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', userId);

      // Отменяем уведомление
      await _cancelNotification(id);
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при удалении напоминания: ${e.toString()}',
      );
    }
  }

  /// Запланировать уведомление для напоминания через OneSignal
  @override
  Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      if (reminder.id == null) {
        throw DatabaseException(message: 'ID напоминания не может быть пустым');
      }

      // Отменяем существующее уведомление, если оно есть
      await _cancelNotification(reminder.id!);

      // Планируем новое уведомление
      await _scheduleNotification(reminder);
    } catch (e) {
      throw DatabaseException(
        message: 'Ошибка при планировании уведомления: ${e.toString()}',
      );
    }
  }

  /// Запланировать уведомление для напоминания (внутренний метод)
  Future<void> _scheduleNotification(ReminderModel reminder) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      // Получаем время уведомления на основе типа напоминания
      final DateTime notificationTime = reminder.notificationDateTime;

      // Проверяем, что время уведомления не в прошлом
      if (notificationTime.isBefore(DateTime.now())) {
        return; // Не планируем уведомления в прошлом
      }

      // Форматируем дату и время для отображения в уведомлении
      final formattedDateTime = _formatTime(reminder.eventDateTime);

      // Создаем параметры для Edge Function
      // Компенсируем часовой пояс для OneSignal
      // OneSignal интерпретирует время как UTC, а затем добавляет часовой пояс при отображении
      // Поэтому нам нужно вычесть часовой пояс дважды
      final offset = DateTime.now().timeZoneOffset;
      final compensatedTime = notificationTime.subtract(offset);
      
      final Map<String, dynamic> requestBody = {
        'reminder_id': reminder.id ?? '',
        'user_id': userId,
        'title': 'Напоминание: ${reminder.title}',
        'body': 'Запланировано на: $formattedDateTime',
        'scheduled_time': compensatedTime.toIso8601String(),
        'external_user_id': userId,
      };

      // Вызываем Supabase Edge Function для планирования уведомления через OneSignal
      await SupabaseService.client.functions.invoke(
        'schedule-notification',
        body: requestBody,
      );

      print('Уведомление запланировано на: $notificationTime');
    } catch (e) {
      print('Ошибка при планировании уведомления: $e');
    }
  }

  /// Отменить уведомление для напоминания
  Future<void> _cancelNotification(String reminderId) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;

      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }

      // Вызываем Supabase Edge Function для отмены удаленного уведомления
      await SupabaseService.client.functions.invoke(
        'cancel-notification',
        body: {'reminder_id': reminderId, 'user_id': userId},
      );

      print('Уведомление отменено для напоминания с ID: $reminderId');
    } catch (e) {
      print('Ошибка при отмене уведомления: $e');
    }
  }

  /// Форматировать время для отображения в уведомлении
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
