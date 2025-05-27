import 'package:notes_app/features/notes/domain/entities/note.dart';

/// Модель заметки для работы с данными
///
/// Расширяет сущность [Note] и добавляет методы для работы с данными
class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.createdAt,
  });

  /// Создает копию модели с новыми значениями
  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
