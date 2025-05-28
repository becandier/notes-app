import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/get_reminder_by_id.dart';
import 'package:notes_app/features/reminders/domain/usecases/update_reminder.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminder_detail_state.dart';

/// Кубит для управления деталями напоминания
class ReminderDetailCubit extends Cubit<ReminderDetailState> {
  final GetReminderById _getReminderById;
  final UpdateReminder _updateReminder;
  
  /// Конструктор
  ReminderDetailCubit({
    required GetReminderById getReminderById,
    required UpdateReminder updateReminder,
  }) : _getReminderById = getReminderById,
       _updateReminder = updateReminder,
       super(ReminderDetailState.initial());
  
  /// Загрузить напоминание по ID
  Future<void> loadReminder(String id) async {
    emit(ReminderDetailState.loading());
    
    final result = await _getReminderById(id);
    
    result.fold(
      (failure) => emit(ReminderDetailState.error(failure.message)),
      (reminder) => emit(ReminderDetailState.loaded(reminder)),
    );
  }
  
  /// Обновить напоминание
  Future<void> updateReminder(Reminder reminder) async {
    emit(ReminderDetailState.loading());
    
    final result = await _updateReminder(reminder);
    
    result.fold(
      (failure) => emit(ReminderDetailState.error(failure.message)),
      (updatedReminder) => emit(ReminderDetailState.loaded(updatedReminder)),
    );
  }
  
  /// Очистить состояние
  void clearState() {
    emit(ReminderDetailState.initial());
  }
}
