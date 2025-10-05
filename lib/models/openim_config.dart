/// OpenIM SDK Configuration
/// 
/// Configuration class for initializing the OpenIM SDK

import 'dart:io' show Platform;

/// Platform enumeration for OpenIM SDK
enum OpenIMPlatform {
  ios(1),
  android(2),
  windows(3),
  macos(4),
  web(5),
  linux(7);
  
  const OpenIMPlatform(this.value);
  final int value;
  
  static OpenIMPlatform get current {
    if (Platform.isIOS) return OpenIMPlatform.ios;
    if (Platform.isAndroid) return OpenIMPlatform.android;
    if (Platform.isWindows) return OpenIMPlatform.windows;
    if (Platform.isMacOS) return OpenIMPlatform.macos;
    if (Platform.isLinux) return OpenIMPlatform.linux;
    return OpenIMPlatform.web; // fallback for web
  }
}

/// Configuration for OpenIM SDK initialization
class OpenIMConfig {
  /// API server URL
  final String apiUrl;
  
  /// WebSocket server URL
  final String wsUrl;
  
  /// Platform (auto-detected if not specified)
  final OpenIMPlatform platform;
  
  /// Data directory for local storage
  final String? dataDir;
  
  /// Log level (1-6, default is 6)
  final int logLevel;
  
  /// Enable encryption
  final bool enableEncryption;
  
  /// Enable compression
  final bool enableCompression;
  
  /// Application name/identifier
  final String? appIdentifier;
  
  OpenIMConfig({
    required this.apiUrl,
    required this.wsUrl,
    OpenIMPlatform? platform,
    this.dataDir,
    this.logLevel = 6,
    this.enableEncryption = false,
    this.enableCompression = false,
    this.appIdentifier,
  }) : platform = platform ?? OpenIMPlatform.current;
  
  /// Convert to JSON for platform channel
  Map<String, dynamic> toJson() => {
    'apiAddr': apiUrl,
    'wsAddr': wsUrl,
    'platformID': platform.value,
    'dataDir': dataDir ?? '',
    'logLevel': logLevel,
    'isNeedEncryption': enableEncryption,
    'isCompression': enableCompression,
    'systemType': 'enhanced_flutter',
    'appIdentifier': appIdentifier,
  };
  
  /// Create from JSON
  factory OpenIMConfig.fromJson(Map<String, dynamic> json) => OpenIMConfig(
    apiUrl: json['apiAddr'] ?? '',
    wsUrl: json['wsAddr'] ?? '',
    platform: OpenIMPlatform.values.firstWhere(
      (p) => p.value == json['platformID'], 
      orElse: () => OpenIMPlatform.current,
    ),
    dataDir: json['dataDir'],
    logLevel: json['logLevel'] ?? 6,
    enableEncryption: json['isNeedEncryption'] ?? false,
    enableCompression: json['isCompression'] ?? false,
    appIdentifier: json['appIdentifier'],
  );
  
  @override
  String toString() => 'OpenIMConfig(apiUrl: $apiUrl, wsUrl: $wsUrl, platform: $platform)';
}