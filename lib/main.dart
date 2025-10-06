import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presales_app_store/src/features/auth/presentation/login_page.dart';
import 'package:presales_app_store/src/services/auth_service.dart';
import 'package:presales_app_store/src/features/apps/presentation/app_list_page.dart';
import 'package:presales_app_store/src/features/admin/presentation/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

final initialRouteProvider = FutureProvider<String>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final token = await authService.getToken();
  // In a real app, you'd decode the token to get the role.
  // For this demo, we'll use a simplified check. A more robust solution
  // (e.g., decoding a JWT) would be needed for a production app.
  if (token != null) {
    // This is NOT a secure way to check roles. For demo purposes only.
    if (token.contains("admin")) {
        return '/admin';
    }
    return '/apps';
  }
  return '/login';
});


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialRoute = ref.watch(initialRouteProvider);

    return MaterialApp(
      title: 'Internal App Store',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initialRoute.when(
        data: (route) => _buildInitialScreen(route),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) => const Scaffold(body: Center(child: Text('Error loading app'))),
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/apps': (context) => const AppListPage(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }

  Widget _buildInitialScreen(String route) {
    switch (route) {
      case '/login':
        return const LoginPage();
      case '/apps':
        return const AppListPage();
      case '/admin':
        return const AdminDashboard();
      default:
        return const LoginPage();
    }
  }
}