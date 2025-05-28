import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис для работы с Supabase
class SupabaseService {
  static const String _supabaseUrl = 'https://rlwysrhhcfkbdgbiwjov.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJsd3lzcmhoY2ZrYmRnYml3am92Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgzMzkyNTUsImV4cCI6MjA2MzkxNTI1NX0.l316byTBBdAEuLXlyN6CFr1JRWPHOunJQsV5gqkyPJg';
  
  /// Инициализация Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }
  
  /// Получение экземпляра Supabase клиента
  static SupabaseClient get client => Supabase.instance.client;
}
