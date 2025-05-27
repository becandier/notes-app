/// Базовое исключение для всех ошибок в приложении
class AppException implements Exception {
  final String message;

  AppException({required this.message});
}

/// Исключение базы данных
class DatabaseException extends AppException {
  DatabaseException({required super.message});
}

/// Исключение валидации
class ValidationException extends AppException {
  ValidationException({required super.message});
}

/// Неизвестное исключение
class UnknownException extends AppException {
  UnknownException({required super.message});
}
