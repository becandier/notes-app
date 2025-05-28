import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Сервис для работы с OneSignal
class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();

  /// Фабричный конструктор
  factory OneSignalService() {
    return _instance;
  }

  /// Приватный конструктор
  OneSignalService._internal();

  /// OneSignal App ID
  static const String appId = '4d97941f-ec53-49d1-8ad6-b7beaeb10d5b';

  /// OneSignal API Key
  static const String apiKey =
      'os_v2_app_jwlzih7mkne5dcwww67k5minlpisbbhzbu6e2mv7kugpoept6ivdvhv6fcfdqd4jue4xfyop27mumuqtfycaw5d7f2wvb2dacs6snea';

  /// Инициализация сервиса
  Future<void> initialize() async {
    try {
      // Инициализируем OneSignal
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      OneSignal.initialize(appId);

      // Запрашиваем разрешения для уведомлений
      await OneSignal.Notifications.requestPermission(true);

      // Настраиваем обработчик нажатий на уведомления
      OneSignal.Notifications.addClickListener((event) {
        print('Нажато на уведомление OneSignal: ${event.notification.title}');

        // Получаем ID напоминания из дополнительных данных
        final reminderId =
            event.notification.additionalData?['reminder_id'] as String?;

        if (reminderId != null) {
          // Здесь можно добавить навигацию к деталям напоминания
          print('ID напоминания: $reminderId');
        }
      });

      print('OneSignal успешно инициализирован');
    } catch (e) {
      print('Ошибка инициализации OneSignal: $e');
    }
  }

  /// Привязка пользователя по externalUserId
  Future<void> setExternalUserId(String userId) async {
    try {
      await OneSignal.login(userId);
      print('OneSignal: пользователь привязан с ID: $userId');
    } catch (e) {
      print('Ошибка при привязке пользователя OneSignal: $e');
    }
  }

  /// Отвязка пользователя
  Future<void> removeExternalUserId() async {
    try {
      await OneSignal.logout();
      print('OneSignal: пользователь отвязан');
    } catch (e) {
      print('Ошибка при отвязке пользователя OneSignal: $e');
    }
  }
}
