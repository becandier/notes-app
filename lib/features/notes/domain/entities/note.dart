import 'package:equatable/equatable.dart';

/// Сущность заметки
/// 
/// Содержит основную информацию о заметке: идентификатор, заголовок, текст и дату создания
class Note extends Equatable {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt];
}
