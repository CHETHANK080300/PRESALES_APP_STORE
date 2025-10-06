import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_store_frontend/src/models/app_model.dart';
import 'package:app_store_frontend/src/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

final appListProvider = FutureProvider<List<App>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getApps();
});

class AppListPage extends ConsumerWidget {
  const AppListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appList = ref.watch(appListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Apps')),
      body: appList.when(
        data: (apps) => ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return ListTile(
              title: Text(app.name),
              subtitle: Text('v${app.version} - ${app.purpose}'),
              trailing: ElevatedButton(
                onPressed: () => _downloadApp(app),
                child: const Text('Download'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _downloadApp(App app) async {
    final url = app.platform == AppPlatform.ios
        ? 'itms-services://?action=download-manifest&url=${app.plistUrl}'
        : app.downloadUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}