import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// 运行环境配置
class EnvironmentConfig {
  /// 是否是Web环境
  static bool get isWeb => kIsWeb;
  
  /// 是否是移动端
  static bool get isMobile => !isWeb && (Platform.isAndroid || Platform.isIOS);
  
  /// 是否是桌面端
  static bool get isDesktop => !isWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  /// 获取操作系统名称
  static String get operatingSystem {
    if (isWeb) return 'web';
    return Platform.operatingSystem;
  }
  
  /// 获取操作系统版本
  static String get operatingSystemVersion {
    if (isWeb) return 'web';
    return Platform.operatingSystemVersion;
  }

  /// 是否为开发环境
  static bool get isDevelopment => !kReleaseMode;
  
  /// 是否为生产环境
  static bool get isProduction => kReleaseMode;
} 