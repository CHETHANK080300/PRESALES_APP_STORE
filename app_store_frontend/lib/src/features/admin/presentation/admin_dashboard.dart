import 'package:flutter/material.dart';
import 'package:app_store_frontend/src/features/admin/presentation/upload_form.dart';
import 'package:app_store_frontend/src/features/apps/presentation/app_list_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'App List'),
              Tab(text: 'Upload App'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AppListPage(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: UploadForm(),
            ),
          ],
        ),
      ),
    );
  }
}