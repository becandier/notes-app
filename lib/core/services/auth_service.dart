import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис для работы с аутентификацией
class AuthService {
  /// Получить текущего пользователя
  User? get currentUser => SupabaseService.client.auth.currentUser;
  
  /// Проверить, авторизован ли пользователь
  bool get isAuthenticated => currentUser != null;
  
  /// Регистрация нового пользователя
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw AppAuthException(message: 'Не удалось зарегистрировать пользователя');
      }
      
      return response.user!;
    } catch (e) {
      throw AppAuthException(message: 'Ошибка при регистрации: ${e.toString()}');
    }
  }
  
  /// Вход пользователя
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw AppAuthException(message: 'Неверный email или пароль');
      }
      
      return response.user!;
    } catch (e) {
      throw AppAuthException(message: 'Ошибка при входе: ${e.toString()}');
    }
  }
  
  /// Выход пользователя
  Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (e) {
      throw AppAuthException(message: 'Ошибка при выходе: ${e.toString()}');
    }
  }
  
  /// Сброс пароля
  Future<void> resetPassword(String email) async {
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw AppAuthException(message: 'Ошибка при сбросе пароля: ${e.toString()}');
    }
  }
  
  /// Обновление пароля
  Future<void> updatePassword(String password) async {
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(password: password),
      );
    } catch (e) {
      throw AppAuthException(message: 'Ошибка при обновлении пароля: ${e.toString()}');
    }
  }
}
