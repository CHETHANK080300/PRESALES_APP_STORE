import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presales_app_store/src/models/app_model.dart';
import 'package:presales_app_store/src/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

final appListProvider = FutureProvider.autoDispose<List<App>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return apiService.getApps();
});

class AppListPage extends ConsumerWidget {
  const AppListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appListAsync = ref.watch(appListProvider);

    return appListAsync.when(
      data: (apps) {
        if (apps.isEmpty) {
          return const Center(child: Text('No applications found.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(appListProvider.future),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              return AppCard(app: apps[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Failed to load apps: $error'),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.app});
  final App app;

  void _downloadApp(App app) async {
    final urlString = app.platform == AppPlatform.ios
        ? 'itms-services://?action=download-manifest&url=${app.plistUrl}'
        : app.downloadUrl;

    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  app.iconUrl,
                  width: 48,
                  height: 48,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.apps, size: 48, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(app.bundleId, style: textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // This section can be for action buttons
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
                    IconButton(onPressed: () => _downloadApp(app), icon: const Icon(Icons.download)),
                    Text(app.shortCode, style: textTheme.titleMedium),
                  ],
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("STATUS", style: textTheme.labelSmall),
                    Text(app.status, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("INSTALLATIONS LEFT", style: textTheme.labelSmall),
                    Text(app.installationsLeft?.toString() ?? 'N/A', style: textTheme.bodyMedium),
                     const SizedBox(height: 4),
                    Text("EXPIRES", style: textTheme.labelSmall),
                    Text(app.expiresIn ?? 'N/A', style: textTheme.bodyMedium),
                  ],
                )
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoColumn(title: "PLATFORM", value: app.platform.name.toUpperCase()),
                _InfoColumn(title: "VERSION", value: app.version),
                _InfoColumn(title: "BUILD", value: app.buildNumber),
                _InfoColumn(title: "UPLOADED", value: app.uploadedDate),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textTheme.labelSmall),
        Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}