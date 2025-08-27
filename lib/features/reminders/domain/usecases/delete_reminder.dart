import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Use case для удаления напоминания
class DeleteReminder {
  final ReminderRepository repository;
  
  /// Конструктор
  DeleteReminder(this.repository);
  
  /// Выполнить use case
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteReminder(id);
  }
}
