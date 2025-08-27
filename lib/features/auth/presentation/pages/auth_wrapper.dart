import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:notes_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:notes_app/features/auth/presentation/pages/login_page.dart';
import 'package:notes_app/features/home/presentation/pages/home_page.dart';

/// Обертка для проверки аутентификации
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AppAuthState>(
      builder: (context, state) {
        // Если загружается, показываем индикатор загрузки
        if (state.status == AuthStatus.loading ||
            state.status == AuthStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Если аутентифицирован, показываем главную страницу
        if (state.status == AuthStatus.authenticated) {
          return const HomePage();
        }

        // По умолчанию показываем экран входа
        return const LoginPage();
      },
    );
  }
}
