import 'package:intl/intl.dart';

/// Утилита для форматирования даты
class DateFormatter {
  /// Форматирует дату в формате "dd.MM.yyyy HH:mm"
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy HH:mm');
    return formatter.format(dateTime);
  }
  
  /// Форматирует дату в формате "dd.MM.yyyy"
  static String formatDate(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(dateTime);
  }
  
  /// Форматирует время в формате "HH:mm"
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
