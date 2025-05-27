import 'package:equatable/equatable.dart';
import 'package:notes_app/features/notes/domain/entities/note.dart';

/// Базовое состояние для работы с отдельной заметкой
abstract class NoteDetailState extends Equatable {
  const NoteDetailState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class NoteDetailInitial extends NoteDetailState {
  const NoteDetailInitial();
}

/// Состояние загрузки
class NoteDetailLoading extends NoteDetailState {
  const NoteDetailLoading();
}

/// Состояние загруженной заметки
class NoteDetailLoaded extends NoteDetailState {
  final Note note;

  const NoteDetailLoaded({required this.note});

  @override
  List<Object> get props => [note];
}

/// Состояние ошибки
class NoteDetailError extends NoteDetailState {
  final String message;

  const NoteDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Состояние действия с заметкой (создание, обновление, удаление)
class NoteActionCompleted extends NoteDetailState {
  final bool isSuccess;
  final String? message;
  final Note? note;
  final NoteAction action;

  const NoteActionCompleted({
    required this.isSuccess,
    required this.action,
    this.message,
    this.note,
  });

  @override
  List<Object?> get props => [isSuccess, message, note, action];
}

/// Типы действий с заметкой
enum NoteAction {
  create,
  update,
  delete,
  load
}
