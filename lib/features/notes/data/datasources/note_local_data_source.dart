import 'package:drift/drift.dart';
import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/features/notes/data/datasources/database.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';

/// Абстрактный класс для локального источника данных заметок
abstract class NoteLocalDataSource {
  /// Получить все заметки
  Future<List<NoteModel>> getNotes();
  
  /// Получить заметки с фильтрацией по поисковому запросу
  Future<List<NoteModel>> searchNotes(String query);
  
  /// Получить заметку по идентификатору
  Future<NoteModel> getNoteById(int id);
  
  /// Создать новую заметку
  Future<NoteModel> createNote(NoteModel note);
  
  /// Обновить существующую заметку
  Future<NoteModel> updateNote(NoteModel note);
  
  /// Удалить заметку по идентификатору
  Future<void> deleteNote(int id);
}

/// Реализация локального источника данных заметок с использованием Drift
class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final AppDatabase _database;
  
  NoteLocalDataSourceImpl({AppDatabase? database}) : _database = database ?? AppDatabase();
  
  /// Конвертирует сущность Note из Drift в модель NoteModel
  NoteModel _mapToModel(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
    );
  }
  
  /// Создает Companion для Drift из модели NoteModel
  NotesCompanion _mapToCompanion(NoteModel note) {
    return NotesCompanion(
      id: note.id == null ? const Value.absent() : Value(note.id!),
      title: Value(note.title),
      content: Value(note.content),
      createdAt: Value(note.createdAt),
    );
  }
  
  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final notes = await _database.getAllNotes();
      return notes.map(_mapToModel).toList();
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при получении заметок: ${e.toString()}');
    }
  }
  
  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final notes = await _database.searchNotes(query);
      return notes.map(_mapToModel).toList();
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при поиске заметок: ${e.toString()}');
    }
  }
  
  @override
  Future<NoteModel> getNoteById(int id) async {
    try {
      final note = await _database.getNoteById(id);
      return _mapToModel(note);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при получении заметки: ${e.toString()}');
    }
  }
  
  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final companion = _mapToCompanion(note);
      final id = await _database.createNote(companion);
      return note.copyWith(id: id);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при создании заметки: ${e.toString()}');
    }
  }
  
  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      if (note.id == null) {
        throw DatabaseException(message: 'ID заметки не может быть пустым');
      }
      
      final companion = _mapToCompanion(note);
      await _database.updateNote(companion);
      return note;
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при обновлении заметки: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteNote(int id) async {
    try {
      await _database.deleteNote(id);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при удалении заметки: ${e.toString()}');
    }
  }
}
