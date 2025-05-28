import 'package:equatable/equatable.dart';

/// Тип напоминания (за сколько времени до события)
enum ReminderType {
  /// Точное время
  exact,
  
  /// За 5 минут
  fiveMinutes,
  
  /// За 10 минут
  tenMinutes,
  
  /// За 15 минут
  fifteenMinutes,
  
  /// За 30 минут
  thirtyMinutes,
}

/// Сущность напоминания
class Reminder extends Equatable {
  /// Идентификатор напоминания
  final String? id;
  
  /// Заголовок напоминания
  final String title;
  
  /// Дата и время события
  final DateTime eventDateTime;
  
  /// Дата и время уведомления
  final DateTime notificationDateTime;
  
  /// Тип напоминания
  final ReminderType reminderType;
  
  /// ID пользователя
  final String userId;
  
  /// Конструктор
  const Reminder({
    this.id,
    required this.title,
    required this.eventDateTime,
    required this.notificationDateTime,
    required this.reminderType,
    required this.userId,
  });
  
  /// Вычисляет время уведомления на основе типа напоминания
  static DateTime calculateNotificationTime(DateTime eventTime, ReminderType type) {
    switch (type) {
      case ReminderType.exact:
        return eventTime;
      case ReminderType.fiveMinutes:
        return eventTime.subtract(const Duration(minutes: 5));
      case ReminderType.tenMinutes:
        return eventTime.subtract(const Duration(minutes: 10));
      case ReminderType.fifteenMinutes:
        return eventTime.subtract(const Duration(minutes: 15));
      case ReminderType.thirtyMinutes:
        return eventTime.subtract(const Duration(minutes: 30));
    }
  }
  
  @override
  List<Object?> get props => [id, title, eventDateTime, notificationDateTime, reminderType, userId];
}
