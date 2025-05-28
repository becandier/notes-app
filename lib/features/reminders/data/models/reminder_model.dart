import 'package:notes_app/features/reminders/domain/entities/reminder.dart';

/// Модель напоминания для работы с данными
class ReminderModel extends Reminder {
  /// Конструктор
  const ReminderModel({
    super.id,
    required super.title,
    required super.eventDateTime,
    required super.notificationDateTime,
    required super.reminderType,
    required super.userId,
  });
  
  /// Создание модели из JSON
  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    final reminderType = _parseReminderType(json['reminder_type']);
    final eventDateTime = DateTime.parse(json['event_datetime']);
    
    return ReminderModel(
      id: json['id'],
      title: json['title'],
      eventDateTime: eventDateTime,
      notificationDateTime: json['notification_datetime'] != null 
          ? DateTime.parse(json['notification_datetime'])
          : Reminder.calculateNotificationTime(eventDateTime, reminderType),
      reminderType: reminderType,
      userId: json['user_id'],
    );
  }
  
  /// Преобразование модели в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'event_datetime': eventDateTime.toIso8601String(),
      'notification_datetime': notificationDateTime.toIso8601String(),
      'reminder_type': reminderType.name,
      'user_id': userId,
    };
  }
  
  /// Создание копии с новыми значениями
  ReminderModel copyWith({
    String? id,
    String? title,
    DateTime? eventDateTime,
    DateTime? notificationDateTime,
    ReminderType? reminderType,
    String? userId,
  }) {
    final newEventDateTime = eventDateTime ?? this.eventDateTime;
    final newReminderType = reminderType ?? this.reminderType;
    
    return ReminderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      eventDateTime: newEventDateTime,
      notificationDateTime: notificationDateTime ?? 
          (reminderType != null ? Reminder.calculateNotificationTime(newEventDateTime, newReminderType) : this.notificationDateTime),
      reminderType: newReminderType,
      userId: userId ?? this.userId,
    );
  }
  
  /// Парсинг типа напоминания из строки
  static ReminderType _parseReminderType(String type) {
    switch (type) {
      case 'exact':
        return ReminderType.exact;
      case 'fiveMinutes':
        return ReminderType.fiveMinutes;
      case 'tenMinutes':
        return ReminderType.tenMinutes;
      case 'fifteenMinutes':
        return ReminderType.fifteenMinutes;
      case 'thirtyMinutes':
        return ReminderType.thirtyMinutes;
      default:
        return ReminderType.exact;
    }
  }
}
