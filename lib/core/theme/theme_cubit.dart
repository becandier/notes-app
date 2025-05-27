import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// Состояние темы приложения
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

/// Кубит для управления темой приложения
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  /// Переключить тему
  void toggleTheme() {
    final currentTheme = state.themeMode;
    
    if (currentTheme == ThemeMode.system) {
      emit(const ThemeState(themeMode: ThemeMode.light));
    } else if (currentTheme == ThemeMode.light) {
      emit(const ThemeState(themeMode: ThemeMode.dark));
    } else {
      emit(const ThemeState(themeMode: ThemeMode.system));
    }
  }

  /// Установить светлую тему
  void setLightTheme() {
    emit(const ThemeState(themeMode: ThemeMode.light));
  }

  /// Установить темную тему
  void setDarkTheme() {
    emit(const ThemeState(themeMode: ThemeMode.dark));
  }

  /// Установить системную тему
  void setSystemTheme() {
    emit(const ThemeState(themeMode: ThemeMode.system));
  }
}
