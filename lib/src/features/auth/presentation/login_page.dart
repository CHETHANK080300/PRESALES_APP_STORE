import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presales_app_store/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:presales_app_store/src/services/api_service.dart';
import 'package:presales_app_store/src/services/auth_service.dart';

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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else if (next is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error)),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.2)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 80,
                        placeholderBuilder: (context) => const SizedBox(
                          height: 80,
                          child: Center(child: Text("Logo", style: TextStyle(color: Colors.white, fontSize: 24),))
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Appzillon App Store',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Consumer(
                        builder: (context, ref, child) {
                          final loginState = ref.watch(loginProvider);
                          if (loginState is LoginLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ref.read(loginProvider.notifier).login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );
                              }
                            },
                            child: const Text('Login', style: TextStyle(fontSize: 18)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}