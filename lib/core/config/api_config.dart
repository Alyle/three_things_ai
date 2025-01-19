/// API配置
class ApiConfig {
  /// one-api 基础URL
   static const String baseUrl = 'http://42.192.114.26:3000/v1';  
  
  /// API密钥
  static const String apiKey = 'sk-jSRg1aZu4KXf2IUmCb7817B264F74b07B5Bc4d7b5cCb60B0';   // one-api
  // static const String apiKey = 'sk-c6b4a21b9aaf112e'; // dify on 腾讯云
  
  /// 模型名称
  static const String model = 'qwen-max';
  
  /// OpenAI 模型
  // gpt-4-turbo-preview    // GPT-4 Turbo 预览版
  // gpt-4-0125-preview    // GPT-4 Turbo 1月版
  // gpt-4-1106-preview    // GPT-4 Turbo 11月版
  // gpt-4                 // GPT-4 基础版
  // gpt-3.5-turbo         // GPT-3.5 Turbo
  // gpt-3.5-turbo-1106    // GPT-3.5 Turbo 11月版
  
  /// Anthropic Claude 模型
  // claude-3-opus-20240229    // Claude 3 Opus
  // claude-3-sonnet-20240229  // Claude 3 Sonnet
  // claude-2.1                // Claude 2.1
  // claude-2.0                // Claude 2.0
  // claude-instant-1.2        // Claude Instant
  
  /// DeepSeek 模型
  // deepseek-chat             // DeepSeek Chat
  // deepseek-coder           // DeepSeek Coder
  
  /// 阿里通义千问模型
  // qwen-turbo                // 通义千问 Turbo
  // qwen-plus                 // 通义千问 Plus
  // qwen-max                  // 通义千问 Max
  // qwen-max-1201             // 通义千问 Max 12月版
  // qwen-max-longcontext      // 通义千问 Max 长文本版
  
  /// 百度文心千帆模型
  // ernie-bot-4              // 文心一言 4.0
  // ernie-bot-8k             // 文心一言 8K
  // ernie-bot-turbo          // 文心一言 Turbo
  // ernie-speed              // 文心一言 Speed
  
  /// 讯飞星火认知模型
  // spark-v3.5               // 星火认知 V3.5
  // spark-v3.1               // 星火认知 V3.1
  // spark-v2.1               // 星火认知 V2.1
  // spark-v1.5               // 星火认知 V1.5
  
  /// 超时时间
  static const Duration timeout = Duration(seconds: 30);
  
  /// 最大重试次数
  static const int maxRetries = 3;
} 