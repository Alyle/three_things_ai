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
    enableCache: true,
  );
  
  /// UI相关配置
  static const ui = _UIConfig(
    defaultFontFamily: 'NotoSansSC',
    loadingAnimationMillis: 300,
    scrollAnimationMillis: 200,
  );
  
  /// 文件路径配置
  static const path = _PathConfig(
    systemPrompt: 'lib/core/config/prompts/system_prompt.md',
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
    required this.enableCache,
  });
  
  /// 是否启用JSON响应检查
  final bool enableJsonCheck;
  
  /// 是否启用调试日志
  final bool enableDebugLog;
  
  /// 是否启用本地缓存
  final bool enableCache;
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

/// 文件路径配置
class _PathConfig {
  const _PathConfig({
    required this.systemPrompt,
  });
  
  /// 系统提示词文件路径
  final String systemPrompt;
} 