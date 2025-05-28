import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/home/presentation/bloc/home_state.dart';

/// Кубит для управления состоянием главной страницы
class HomeCubit extends Cubit<HomeState> {
  /// Конструктор
  HomeCubit() : super(const HomeState());

  /// Изменить текущую вкладку
  void changeTab(int index) {
    emit(state.copyWith(tabIndex: index));
  }
}
