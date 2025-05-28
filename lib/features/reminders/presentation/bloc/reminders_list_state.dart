import 'package:equatable/equatable.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';

/// Статус списка напоминаний
enum RemindersListStatus {
  /// Начальное состояние
  initial,
  
  /// Загрузка
  loading,
  
  /// Загружено
  loaded,
  
  /// Ошибка
  error,
}

/// Состояние списка напоминаний
class RemindersListState extends Equatable {
  /// Статус списка напоминаний
  final RemindersListStatus status;
  
  /// Список напоминаний
  final List<Reminder> reminders;
  
  /// Сообщение об ошибке
  final String? errorMessage;
  
  /// Конструктор
  const RemindersListState({
    this.status = RemindersListStatus.initial,
    this.reminders = const [],
    this.errorMessage,
  });
  
  /// Начальное состояние
  factory RemindersListState.initial() => const RemindersListState();
  
  /// Состояние загрузки
  factory RemindersListState.loading() => const RemindersListState(
    status: RemindersListStatus.loading,
  );
  
  /// Состояние с загруженными данными
  factory RemindersListState.loaded(List<Reminder> reminders) => RemindersListState(
    status: RemindersListStatus.loaded,
    reminders: reminders,
  );
  
  /// Состояние ошибки
  factory RemindersListState.error(String message) => RemindersListState(
    status: RemindersListStatus.error,
    errorMessage: message,
  );
  
  /// Создать копию состояния с новыми значениями
  RemindersListState copyWith({
    RemindersListStatus? status,
    List<Reminder>? reminders,
    String? errorMessage,
  }) {
    return RemindersListState(
      status: status ?? this.status,
      reminders: reminders ?? this.reminders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, reminders, errorMessage];
}
