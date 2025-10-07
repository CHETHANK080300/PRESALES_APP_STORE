import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presales_app_store/src/features/auth/presentation/login_page.dart';
import 'package:presales_app_store/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:presales_app_store/src/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

final initialPageProvider = FutureProvider<Widget>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final token = await authService.getToken();
  if (token != null) {
    // In a real app, you would also validate the token here.
    return const DashboardPage();
  }
  return const LoginPage();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialPage = ref.watch(initialPageProvider);

    return MaterialApp(
      title: 'Appzillon App Store',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[600],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo[500],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: initialPage.when(
        data: (page) => page,
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) => const Scaffold(
          body: Center(child: Text('Error loading application')),
        ),
      ),
      // We are using the home property to handle initial routing,
      // but you could expand this with a full routing solution like go_router.
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}