import 'package:flutter/foundation.dart';

enum AppPlatform { android, ios }

class App {
  final String id;
  final String name;
  final String bundleId;
  final String iconUrl;
  final String version;
  final String buildNumber;
  final String uploadedDate;
  final String shortCode;
  final String status;
  final int? installationsLeft;
  final String? expiresIn;
  final AppPlatform platform;
  final String downloadUrl;
  final String? plistUrl;

  App({
    required this.id,
    required this.name,
    required this.bundleId,
    required this.iconUrl,
    required this.version,
    required this.buildNumber,
    required this.uploadedDate,
    required this.shortCode,
    required this.status,
    this.installationsLeft,
    this.expiresIn,
    required this.platform,
    required this.downloadUrl,
    this.plistUrl,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      name: json['name'],
      bundleId: json['bundle_id'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      version: json['version'],
      buildNumber: json['build_number'] ?? '',
      uploadedDate: json['uploaded_date'] ?? '',
      shortCode: json['short_code'] ?? '',
      status: json['status'] ?? 'N/A',
      installationsLeft: json['installations_left'],
      expiresIn: json['expires_in'],
      platform: (json['platform'] as String).toAppPlatform(),
      downloadUrl: json['download_url'],
      plistUrl: json['plist_url'],
    );
  }
}

extension on String {
  AppPlatform toAppPlatform() {
    switch (this.toLowerCase()) {
      case 'android':
        return AppPlatform.android;
      case 'ios':
        return AppPlatform.ios;
      default:
        // Default to a platform or throw an error, depending on requirements
        return AppPlatform.android;
    }
  }
}