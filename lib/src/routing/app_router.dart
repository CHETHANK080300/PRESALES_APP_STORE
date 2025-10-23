import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presales_app_store/src/features/admin/presentation/upload_page.dart';
import 'package:presales_app_store/src/features/auth/presentation/login_page.dart';
import 'package:presales_app_store/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:presales_app_store/src/services/auth_service.dart';

// Provider for the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true, // Useful for debugging

    // Redirect logic
    redirect: (BuildContext context, GoRouterState state) async {
      final isAuthenticated = await authService.isAuthenticated();
      final isLoggingIn = state.matchedLocation == '/login';

      // If user is not authenticated and not on the login page, redirect to login
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // If user is authenticated and on the login page, redirect to dashboard
      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      // No redirect needed
      return null;
    },

    // App routes
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardPage();
        },
        routes: <RouteBase>[
          // Sub-route for the upload page
          GoRoute(
            path: 'upload',
            builder: (BuildContext context, GoRouterState state) {
              return const UploadPage();
            },
          ),
        ],
      ),
    ],
  );
});