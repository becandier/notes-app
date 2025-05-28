import 'package:equatable/equatable.dart';

/// Базовый класс для всех ошибок в приложении
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Ошибка базы данных
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

/// Ошибка аутентификации
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Ошибка валидации
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Неизвестная ошибка
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
