import 'package:equatable/equatable.dart';

/// Сущность заметки
/// 
/// Содержит основную информацию о заметке: идентификатор, заголовок, текст, дату создания и идентификатор пользователя
class Note extends Equatable {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? userId;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.userId,
  });

  @override
  List<Object?> get props => [id, title, content, createdAt, userId];
}
