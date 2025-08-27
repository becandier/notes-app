# Notes App 📝

Кроссплатформенное приложение для заметок на Flutter с Clean Architecture.

## 🏗️ Архитектура

**Clean Architecture** + **Feature-First** подход:
- `core/` - общие компоненты (DI, сервисы, темы)
- `features/` - модули по функциональности (auth, notes, reminders)
- Каждый модуль: `data/` → `domain/` → `presentation/`

## 🛠️ Технологический стек

### Основные технологии
- **Flutter 3.7.2+** - Кроссплатформенная разработка
- **Dart** - Язык программирования

### Управление состоянием
- **flutter_bloc 8.1.4** - Реактивное управление состоянием
- **equatable 2.0.5** - Сравнение объектов

### Ключевые технологии
- **Drift 2.16.0** - Type-safe SQL ORM
- **Supabase 2.3.4** - Backend синхронизация
- **get_it 7.6.7** - Dependency Injection
- **dartz 0.10.1** - Функциональное программирование
- **Firebase** - Push-уведомления
- **OneSignal** - Дополнительные уведомления

## 🔧 Ключевые особенности

- **BLoC** для управления состоянием
- **Drift** для type-safe работы с БД
- **Either** для функциональной обработки ошибок
- **GetIt** для dependency injection
- **Clean Architecture** с разделением на слои

## 📱 Функциональность

- ✅ CRUD операции с заметками
- ✅ Поиск и сортировка
- ✅ Темная/светлая тема
- ✅ Синхронизация с Supabase
- ✅ Push-уведомления
- ✅ Напоминания
- ✅ Аутентификация

## 🚀 Запуск

```bash
flutter pub get
flutter packages pub run build_runner build
flutter run
```

**Требования:** Flutter 3.7.2+, Firebase и Supabase конфигурации


