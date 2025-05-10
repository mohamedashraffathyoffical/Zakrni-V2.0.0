// This is a minimal shim to make package_info_plus work on web platforms
// It provides a dummy PackageInfo class with default values

class PackageInfo {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String buildSignature;
  final String? installerStore;

  PackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.buildSignature,
    this.installerStore,
  });

  static Future<PackageInfo> fromPlatform() async {
    return PackageInfo(
      appName: 'Zakrni – ذكرني',
      packageName: 'com.example.zakrni',
      version: '2.0.0',
      buildNumber: '2',
      buildSignature: '',
      installerStore: null,
    );
  }
}
