import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presales_app_store/src/features/admin/presentation/upload_page.dart';
import 'package:presales_app_store/src/features/apps/presentation/app_list_page.dart';
import 'package:presales_app_store/src/features/auth/presentation/login_page.dart';
import 'package:presales_app_store/src/services/auth_service.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  void _signOut() async {
    await ref.read(authServiceProvider).logout();
    // Ensure the navigator context is valid before using it.
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/images/nbf-dash-img.svg',
          height: 32,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'signOut') {
                _signOut();
              }
              // Handle 'myProfile' or other options here
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Applications',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const UploadPage()),
                    );
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload New App'),
                ),
              ],
            ),
          ),
          const Expanded(
            child: AppListPage(),
          ),
        ],
      ),
    );
  }
}