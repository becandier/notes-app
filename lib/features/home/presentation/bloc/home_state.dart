import 'package:equatable/equatable.dart';

/// Состояние для главной страницы
class HomeState extends Equatable {
  /// Текущий индекс вкладки
  final int tabIndex;

  /// Конструктор
  const HomeState({this.tabIndex = 0});

  /// Создает копию с новыми значениями
  HomeState copyWith({int? tabIndex}) {
    return HomeState(
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [tabIndex];
}
