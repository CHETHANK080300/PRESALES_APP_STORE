import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presales_app_store/src/models/app_model.dart';
import 'package:presales_app_store/src/services/api_service.dart';
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

    return appList.when(
      data: (apps) {
        if (apps.isEmpty) {
          return const Center(child: Text('No apps available.'));
        }
        return ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            final app = apps[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(app.name),
                subtitle: Text('v${app.version} - ${app.purpose}'),
                trailing: ElevatedButton(
                  onPressed: () => _downloadApp(app),
                  child: const Text('Download'),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  void _downloadApp(App app) async {
    final urlString = app.platform == AppPlatform.ios
        ? 'itms-services://?action=download-manifest&url=${app.plistUrl}'
        : app.downloadUrl;

    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Consider showing a SnackBar or an alert to the user
      debugPrint('Could not launch $uri');
    }
  }
}