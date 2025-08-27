import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Use case для получения напоминания по ID
class GetReminderById {
  final ReminderRepository repository;
  
  /// Конструктор
  GetReminderById(this.repository);
  
  /// Выполнить use case
  Future<Either<Failure, Reminder>> call(String id) {
    return repository.getReminderById(id);
  }
}
