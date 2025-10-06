import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_store_frontend/src/services/api_service.dart';
import 'package:app_store_frontend/src/services/auth_service.dart';
import 'package:app_store_frontend/src/features/apps/presentation/app_list_page.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref.read(apiServiceProvider), ref.read(authServiceProvider));
});

class LoginNotifier extends StateNotifier<LoginState> {
  final ApiService _apiService;
  final AuthService _authService;

  LoginNotifier(this._apiService, this._authService) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    try {
      state = LoginLoading();
      final response = await _apiService.login(username, password);
      final token = response['token'];
      await _authService.login(token);
      state = LoginSuccess();
    } catch (e) {
      state = LoginFailure(e.toString());
    }
  }
}

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppListPage()),
        );
      } else if (next is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final loginState = ref.watch(loginProvider);
                if (loginState is LoginLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    ref.read(loginProvider.notifier).login(
                          usernameController.text,
                          passwordController.text,
                        );
                  },
                  child: const Text('Login'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}