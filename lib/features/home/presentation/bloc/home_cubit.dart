import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/home/presentation/bloc/home_state.dart';

/// Кубит для управления состоянием главной страницы
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void changeTab(int index) {
    emit(state.copyWith(tabIndex: index));
  }
}
