import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:presales_app_store/src/services/auth_service.dart';

class CommonAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void signOut() async {
      await ref.read(authServiceProvider).logout();
      // GoRouter's redirect logic will handle navigation to the login page.
      // We can trigger a refresh of the router state.
      // A simple go to login will also work because the redirect will catch it.
      context.go('/login');
    }

    return AppBar(
      automaticallyImplyLeading: false, // To prevent back button on dashboard
      title: SvgPicture.asset(
        'assets/images/logo.svg',
        height: 32,
        // Using a color filter to make the SVG logo white, matching the app bar theme.
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        placeholderBuilder: (context) => const SizedBox(height: 32),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, size: 28),
          onSelected: (value) {
            if (value == 'signOut') {
              signOut();
            }
            // 'myProfile' can be handled here in the future.
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'myProfile',
              child: Text('My Profile'),
            ),
            const PopupMenuItem<String>(
              value: 'signOut',
              child: Text('Sign Out'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}