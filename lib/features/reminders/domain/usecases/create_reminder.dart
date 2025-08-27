import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Use case для создания нового напоминания
class CreateReminder {
  final ReminderRepository repository;
  
  /// Конструктор
  CreateReminder(this.repository);
  
  /// Выполнить use case
  Future<Either<Failure, Reminder>> call(Reminder reminder) {
    return repository.createReminder(reminder);
  }
}
