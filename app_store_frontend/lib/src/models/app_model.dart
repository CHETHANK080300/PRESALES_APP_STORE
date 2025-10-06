import 'package:flutter/foundation.dart';

enum AppPlatform { android, ios }

class App {
  final String id;
  final String name;
  final String version;
  final String purpose;
  final AppPlatform platform;
  final String downloadUrl;
  final String? plistUrl;

  App({
    required this.id,
    required this.name,
    required this.version,
    required this.purpose,
    required this.platform,
    required this.downloadUrl,
    this.plistUrl,
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      purpose: json['purpose'],
      platform: (json['platform'] as String).toAppPlatform(),
      downloadUrl: json['downloadUrl'],
      plistUrl: json['plistUrl'],
    );
  }
}

extension on String {
  AppPlatform toAppPlatform() {
    switch (this) {
      case 'android':
        return AppPlatform.android;
      case 'ios':
        return AppPlatform.ios;
      default:
        throw Exception('Unknown platform: $this');
    }
  }
}