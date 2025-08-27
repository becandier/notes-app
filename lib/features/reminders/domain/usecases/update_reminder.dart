import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Use case для обновления напоминания
class UpdateReminder {
  final ReminderRepository repository;
  
  /// Конструктор
  UpdateReminder(this.repository);
  
  /// Выполнить use case
  Future<Either<Failure, Reminder>> call(Reminder reminder) {
    return repository.updateReminder(reminder);
  }
}
