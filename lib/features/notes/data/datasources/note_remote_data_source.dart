import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/core/services/supabase_service.dart';
import 'package:notes_app/features/notes/data/models/note_model.dart';
import 'package:uuid/uuid.dart';

/// Абстрактный класс для удаленного источника данных заметок
abstract class NoteRemoteDataSource {
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

/// Реализация удаленного источника данных заметок с использованием Supabase
class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final _uuid = const Uuid();
  final _tableName = 'notes';
  
  /// Конвертирует данные из Supabase в модель NoteModel
  NoteModel _mapToModel(Map<String, dynamic> data) {
    return NoteModel(
      id: data['id'] as int,
      title: data['title'] as String,
      content: data['content'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      userId: data['user_id'] as String?,
    );
  }
  
  /// Конвертирует модель NoteModel в данные для Supabase
  Map<String, dynamic> _mapToData(NoteModel note) {
    return {
      if (note.id != null) 'id': note.id,
      'title': note.title,
      'content': note.content,
      'created_at': note.createdAt.toIso8601String(),
      'user_id': note.userId ?? SupabaseService.client.auth.currentUser?.id,
    };
  }
  
  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }
      
      final response = await SupabaseService.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return response.map<NoteModel>((data) => _mapToModel(data)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при получении заметок: ${e.toString()}');
    }
  }
  
  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }
      
      final response = await SupabaseService.client
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return response.map<NoteModel>((data) => _mapToModel(data)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при поиске заметок: ${e.toString()}');
    }
  }
  
  @override
  Future<NoteModel> getNoteById(int id) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) {
        throw DatabaseException(message: 'Пользователь не авторизован');
      }
      
      final response = await SupabaseService.client
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('user_id', userId)
          .single();
      
      return _mapToModel(response);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при получении заметки: ${e.toString()}');
    }
  }
  
  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final data = _mapToData(note);
      
      // Если ID не указан, генерируем его
      if (note.id == null) {
        // Генерируем числовой ID из UUID
        final generatedId = int.parse(_uuid.v4().split('-')[0], radix: 16) % 1000000;
        data['id'] = generatedId;
      }
      
      final response = await SupabaseService.client
          .from(_tableName)
          .insert(data)
          .select()
          .single();
      
      return _mapToModel(response);
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
      
      final noteId = note.id!; // Используем non-null версию ID
      
      final response = await SupabaseService.client
          .from(_tableName)
          .update(_mapToData(note))
          .eq('id', noteId)
          .select()
          .single();
      
      return _mapToModel(response);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при обновлении заметки: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteNote(int id) async {
    try {
      await SupabaseService.client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } catch (e) {
      throw DatabaseException(message: 'Ошибка при удалении заметки: ${e.toString()}');
    }
  }
}
