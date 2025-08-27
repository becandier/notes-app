import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/services/auth_service.dart';
import 'package:notes_app/features/reminders/domain/entities/reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/create_reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/delete_reminder.dart';
import 'package:notes_app/features/reminders/domain/usecases/get_reminders.dart';
import 'package:notes_app/features/reminders/presentation/bloc/reminders_list_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Кубит для управления списком напоминаний
class RemindersListCubit extends Cubit<RemindersListState> {
  final GetReminders _getReminders;
  final CreateReminder _createReminder;
  final DeleteReminder _deleteReminder;
  final AuthService _authService;
  
  /// Получить текущего пользователя
  User? get currentUser => _authService.currentUser;
  
  /// Конструктор
  RemindersListCubit({
    required GetReminders getReminders,
    required CreateReminder createReminder,
    required DeleteReminder deleteReminder,
    required AuthService authService,
  }) : _getReminders = getReminders,
       _createReminder = createReminder,
       _deleteReminder = deleteReminder,
       _authService = authService,
       super(RemindersListState.initial());
  
  /// Загрузить список напоминаний
  Future<void> loadReminders() async {
    emit(RemindersListState.loading());
    
    final result = await _getReminders();
    
    result.fold(
      (failure) => emit(RemindersListState.error(failure.message)),
      (reminders) => emit(RemindersListState.loaded(reminders)),
    );
  }
  
  /// Создать новое напоминание
  Future<void> createReminder(Reminder reminder) async {
    emit(state.copyWith(status: RemindersListStatus.loading));
    
    final result = await _createReminder(reminder);
    
    result.fold(
      (failure) => emit(RemindersListState.error(failure.message)),
      (_) => loadReminders(),
    );
  }
  
  /// Удалить напоминание
  Future<void> deleteReminder(String id) async {
    emit(state.copyWith(status: RemindersListStatus.loading));
    
    final result = await _deleteReminder(id);
    
    result.fold(
      (failure) => emit(RemindersListState.error(failure.message)),
      (_) => loadReminders(),
    );
  }
  
  /// Обновить список напоминаний
  Future<void> refreshReminders() async {
    await loadReminders();
  }
}
