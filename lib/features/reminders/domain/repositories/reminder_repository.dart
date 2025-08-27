import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';

/// Интерфейс репозитория для работы с напоминаниями
abstract class ReminderRepository {
  /// Получить все напоминания пользователя
  Future<Either<Failure, List<Reminder>>> getReminders();
  
  /// Получить напоминание по ID
  Future<Either<Failure, Reminder>> getReminderById(String id);
  
  /// Создать новое напоминание
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder);
  
  /// Обновить напоминание
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);
  
  /// Удалить напоминание
  Future<Either<Failure, void>> deleteReminder(String id);
}
