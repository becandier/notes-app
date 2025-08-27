import 'package:equatable/equatable.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';

/// Статус детальной информации о напоминании
enum ReminderDetailStatus {
  /// Начальное состояние
  initial,
  
  /// Загрузка
  loading,
  
  /// Загружено
  loaded,
  
  /// Ошибка
  error,
}

/// Состояние детальной информации о напоминании
class ReminderDetailState extends Equatable {
  /// Статус детальной информации
  final ReminderDetailStatus status;
  
  /// Напоминание
  final Reminder? reminder;
  
  /// Сообщение об ошибке
  final String? errorMessage;
  
  /// Конструктор
  const ReminderDetailState({
    this.status = ReminderDetailStatus.initial,
    this.reminder,
    this.errorMessage,
  });
  
  /// Начальное состояние
  factory ReminderDetailState.initial() => const ReminderDetailState();
  
  /// Состояние загрузки
  factory ReminderDetailState.loading() => const ReminderDetailState(
    status: ReminderDetailStatus.loading,
  );
  
  /// Состояние с загруженными данными
  factory ReminderDetailState.loaded(Reminder reminder) => ReminderDetailState(
    status: ReminderDetailStatus.loaded,
    reminder: reminder,
  );
  
  /// Состояние ошибки
  factory ReminderDetailState.error(String message) => ReminderDetailState(
    status: ReminderDetailStatus.error,
    errorMessage: message,
  );
  
  /// Создать копию состояния с новыми значениями
  ReminderDetailState copyWith({
    ReminderDetailStatus? status,
    Reminder? reminder,
    String? errorMessage,
  }) {
    return ReminderDetailState(
      status: status ?? this.status,
      reminder: reminder ?? this.reminder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, reminder, errorMessage];
}
