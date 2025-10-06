import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_store_frontend/src/features/auth/presentation/login_page.dart';
import 'package:app_store_frontend/src/services/auth_service.dart';
import 'package:app_store_frontend/src/features/apps/presentation/app_list_page.dart';
import 'package:app_store_frontend/src/features/admin/presentation/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

final initialRouteProvider = FutureProvider<String>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final token = await authService.getToken();
  // In a real app, you'd decode the token to get the role
  // For now, let's assume a token means you're a regular user.
  // A more robust solution would be needed for role-based routing.
  if (token != null) {
    // This is a simplified check. A real app would check the token's validity
    // and decode it to determine the user's role.
    // For this example, we'll just check for a "dummy-admin-token".
    if (token.contains("admin")) { // This is NOT secure, for demo only
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