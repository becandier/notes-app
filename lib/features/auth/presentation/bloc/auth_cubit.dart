import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/di/injection_container.dart';
import 'package:notes_app/core/error/exceptions.dart';
import 'package:notes_app/core/services/auth_service.dart';
import 'package:notes_app/core/services/onesignal_service.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_state.dart';

/// Кубит для управления состоянием аутентификации
class AuthCubit extends Cubit<AppAuthState> {
  final AuthService _authService;

  /// Конструктор
  AuthCubit({required AuthService authService})
    : _authService = authService,
      super(AppAuthState.initial()) {
    checkAuth();
  }

  /// Проверка аутентификации
  Future<void> checkAuth() async {
    // Сначала переводим в состояние загрузки
    emit(AppAuthState.loading());

    try {
      final user = _authService.currentUser;
      print(
        'Проверка аутентификации: пользователь ${user?.email ?? 'не найден'}',
      );

      if (user != null) {
        // Проверяем, что пользователь подтвердил email
        print(
          'Статус подтверждения email: ${user.emailConfirmedAt != null ? 'подтвержден' : 'не подтвержден'}',
        );

        if (user.emailConfirmedAt != null) {
          // Привязываем пользователя к OneSignal
          await sl<OneSignalService>().setExternalUserId(user.id);
          emit(AppAuthState.authenticated(user));
        } else {
          // Если email не подтвержден, выходим из системы и показываем сообщение
          await _authService.signOut();
          emit(
            AppAuthState.unauthenticated(
              'Пожалуйста, подтвердите ваш email перед входом в систему',
            ),
          );
        }
      } else {
        emit(AppAuthState.unauthenticated());
      }
    } catch (e) {
      print('Ошибка при проверке аутентификации: ${e.toString()}');
      // В случае ошибки тоже переводим в состояние unauthenticated
      emit(
        AppAuthState.unauthenticated(
          'Ошибка при проверке аутентификации. Пожалуйста, войдите снова.',
        ),
      );
    }
  }

  /// Регистрация нового пользователя
  Future<void> signUp({required String email, required String password}) async {
    emit(AppAuthState.loading());
    try {
      await _authService.signUp(email: email, password: password);
      // После регистрации пользователь должен подтвердить email
      // Поэтому не переходим сразу в состояние authenticated
      emit(
        AppAuthState.unauthenticated(
          'Регистрация успешна! Пожалуйста, проверьте вашу почту и подтвердите аккаунт, затем войдите в систему.',
        ),
      );
    } on AppAuthException catch (e) {
      emit(AppAuthState.error(e.message));
    } catch (e) {
      emit(AppAuthState.error('Ошибка при регистрации: ${e.toString()}'));
    }
  }

  /// Вход в систему
  Future<void> signIn({required String email, required String password}) async {
    emit(AppAuthState.loading());

    try {
      final user = await _authService.signIn(email: email, password: password);
      
      // Проверяем, что пользователь подтвердил email
      if (user.emailConfirmedAt != null) {
        // Привязываем пользователя к OneSignal
        await sl<OneSignalService>().setExternalUserId(user.id);
        emit(AppAuthState.authenticated(user));
      } else {
        // Если email не подтвержден, выходим из системы и показываем сообщение
        await _authService.signOut();
        emit(
          AppAuthState.unauthenticated(
            'Пожалуйста, подтвердите ваш email перед входом в систему',
          ),
        );
      }
    } catch (e) {
      emit(AppAuthState.error('Ошибка при входе: ${e.toString()}'));
    }
  }

  /// Выход из системы
  Future<void> signOut() async {
    emit(AppAuthState.loading());

    try {
      // Отвязываем пользователя от OneSignal
      await sl<OneSignalService>().removeExternalUserId();
      await _authService.signOut();
      emit(AppAuthState.unauthenticated());
    } catch (e) {
      print('Ошибка при выходе из системы: ${e.toString()}');
      emit(AppAuthState.error('Ошибка при выходе из системы: ${e.toString()}'));
    }
  }

  /// Сброс пароля
  Future<void> resetPassword(String email) async {
    emit(AppAuthState.loading());

    try {
      await _authService.resetPassword(email);
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } on AppAuthException catch (e) {
      emit(AppAuthState.error(e.message));
    } catch (e) {
      emit(AppAuthState.error('Ошибка при сбросе пароля: ${e.toString()}'));
    }
  }
}
