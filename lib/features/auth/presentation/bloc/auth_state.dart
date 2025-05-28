import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Состояния аутентификации
enum AuthStatus {
  /// Начальное состояние
  initial,
  
  /// Загрузка
  loading,
  
  /// Аутентифицирован
  authenticated,
  
  /// Не аутентифицирован
  unauthenticated,
  
  /// Ошибка
  error,
}

/// Состояние аутентификации
class AppAuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AppAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Начальное состояние
  factory AppAuthState.initial() => const AppAuthState(status: AuthStatus.initial);

  /// Состояние загрузки
  factory AppAuthState.loading() => const AppAuthState(status: AuthStatus.loading);

  /// Состояние аутентификации
  factory AppAuthState.authenticated(User user) => AppAuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  /// Состояние без аутентификации
  /// [message] - опциональное сообщение для пользователя
  factory AppAuthState.unauthenticated([String? message]) => AppAuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: message,
      );

  /// Состояние ошибки
  factory AppAuthState.error(String message) => AppAuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// Создает копию состояния с новыми значениями
  AppAuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
