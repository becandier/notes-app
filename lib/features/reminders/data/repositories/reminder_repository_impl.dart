import 'package:dartz/dartz.dart';
import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/core/error/failures.dart';
import 'package:notes_app/features/reminders/data/datasources/reminder_remote_data_source.dart';
import 'package:notes_app/features/reminders/data/models/reminder_model.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/repositories/reminder_repository.dart';

/// Реализация репозитория для работы с напоминаниями
class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource remoteDataSource;

  ReminderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Reminder>>> getReminders() async {
    try {
      final reminders = await remoteDataSource.getReminders();
      return Right(reminders);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> getReminderById(String id) async {
    try {
      final reminder = await remoteDataSource.getReminderById(id);
      return Right(reminder);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder) async {
    try {
      final reminderModel = ReminderModel(
        id: reminder.id,
        title: reminder.title,
        eventDateTime: reminder.eventDateTime,
        notificationDateTime: reminder.notificationDateTime,
        reminderType: reminder.reminderType,
        userId: reminder.userId,
      );

      final createdReminder = await remoteDataSource.createReminder(
        reminderModel,
      );
      return Right(createdReminder);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder) async {
    try {
      final reminderModel = ReminderModel(
        id: reminder.id,
        title: reminder.title,
        eventDateTime: reminder.eventDateTime,
        notificationDateTime: reminder.notificationDateTime,
        reminderType: reminder.reminderType,
        userId: reminder.userId,
      );

      final updatedReminder = await remoteDataSource.updateReminder(
        reminderModel,
      );
      return Right(updatedReminder);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReminder(String id) async {
    try {
      await remoteDataSource.deleteReminder(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
