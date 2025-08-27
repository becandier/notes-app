import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Состояния аутентификации
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AppAuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AppAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  factory AppAuthState.initial() =>
      const AppAuthState(status: AuthStatus.initial);

  factory AppAuthState.loading() =>
      const AppAuthState(status: AuthStatus.loading);

  factory AppAuthState.authenticated(User user) =>
      AppAuthState(status: AuthStatus.authenticated, user: user);

  factory AppAuthState.unauthenticated([String? message]) =>
      AppAuthState(status: AuthStatus.unauthenticated, errorMessage: message);

  factory AppAuthState.error(String message) =>
      AppAuthState(status: AuthStatus.error, errorMessage: message);

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
