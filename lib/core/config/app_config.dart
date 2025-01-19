/// 应用程序配置
class AppConfig {
  /// API相关配置
  static const api = _APIConfig(
    baseUrl: 'http://42.192.114.26:3000/v1',
    apiKey: 'sk-jSRg1aZu4KXf2IUmCb7817B264F74b07B5Bc4d7b5cCb60B0',
    model: 'qwen-max',
    timeoutSeconds: 30,
    maxRetries: 3,
  );
  
  /// 功能开关配置
  static const features = _FeatureConfig(
    enableJsonCheck: false,
    enableDebugLog: true,
    enableLogging: true,      // 总开关
    enableChatLogging: false,  // 聊天日志开关
    enableGoalLogging: true,  // 目标日志开关
    enableDebugLogging: true,  // 调试日志开关
  );
  
  /// UI相关配置
  static const ui = _UIConfig(
    defaultFontFamily: 'NotoSansSC',
    loadingAnimationMillis: 300,
    scrollAnimationMillis: 200,
  );
  
  /// 路径配置
  static const path = _PathConfig(
    webDocumentsPath: '/documents',  // Web环境下的文档目录
    webLogsPath: '/documents/logs',            // Web环境下的日志目录
    webCachePath: '/documents/cache',          // Web环境下的缓存目录
  );
}

/// API相关配置
class _APIConfig {
  const _APIConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
    required this.timeoutSeconds,
    required this.maxRetries,
  });
  
  /// OpenAI API 基础URL
  final String baseUrl;
  
  /// API密钥
  final String apiKey;
  
  /// 模型名称
  final String model;
  
  /// 超时时间（秒）
  final int timeoutSeconds;
  
  /// 最大重试次数
  final int maxRetries;
  
  /// 获取超时时间
  Duration get timeout => Duration(seconds: timeoutSeconds);
}

/// 功能开关配置
class _FeatureConfig {
  const _FeatureConfig({
    required this.enableJsonCheck,
    required this.enableDebugLog, 
    required this.enableLogging,
    required this.enableChatLogging,
    required this.enableGoalLogging,
    required this.enableDebugLogging,
  });
  
  /// 是否启用JSON响应检查
  final bool enableJsonCheck;
  
  /// 是否启用调试日志
  final bool enableDebugLog;

  /// 是否启用日志
  final bool enableLogging;

  /// 是否启用聊天日志
  final bool enableChatLogging;

  /// 是否启用目标日志
  final bool enableGoalLogging;

  /// 是否启用调试日志
  final bool enableDebugLogging;
}

/// UI相关配置
class _UIConfig {
  const _UIConfig({
    required this.defaultFontFamily,
    required this.loadingAnimationMillis,
    required this.scrollAnimationMillis,
  });
  
  /// 默认字体
  final String defaultFontFamily;
  
  /// 加载动画持续时间（毫秒）
  final int loadingAnimationMillis;
  
  /// 滚动动画持续时间（毫秒）
  final int scrollAnimationMillis;
  
  /// 获取加载动画持续时间
  Duration get loadingAnimationDuration => 
      Duration(milliseconds: loadingAnimationMillis);
  
  /// 获取滚动动画持续时间
  Duration get scrollAnimationDuration => 
      Duration(milliseconds: scrollAnimationMillis);
}

/// 路径配置
class _PathConfig {
  const _PathConfig({
    required this.webDocumentsPath,
    required this.webLogsPath,
    required this.webCachePath,
  });
  
  /// Web环境下的文档目录路径
  final String webDocumentsPath;
  
  /// Web环境下的日志目录路径
  final String webLogsPath;
  
  /// Web环境下的缓存目录路径
  final String webCachePath;
}
