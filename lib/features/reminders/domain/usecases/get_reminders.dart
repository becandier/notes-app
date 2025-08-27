import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Use case для получения всех напоминаний пользователя
class GetReminders {
  final ReminderRepository repository;
  
  /// Конструктор
  GetReminders(this.repository);
  
  /// Выполнить use case
  Future<Either<Failure, List<Reminder>>> call() {
    return repository.getReminders();
  }
}
