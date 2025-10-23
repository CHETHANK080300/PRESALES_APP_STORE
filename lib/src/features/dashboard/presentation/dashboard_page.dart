import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presales_app_store/src/common/widgets/common_app_bar.dart';
import 'package:presales_app_store/src/features/apps/presentation/app_list_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: const AppListPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the upload page
          context.go('/dashboard/upload');
        },
        child: const Icon(Icons.upload),
        tooltip: 'Upload New App',
      ),
    );
  }
}