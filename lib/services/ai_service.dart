import 'openai_service.dart';

/// AI服务
class AIService {
  final _openai = OpenAIService();

  /// 获取聊天响应流
  Stream<Map<String, dynamic>> getChatResponseStream(String content) {
    return _openai.getChatResponseStream(content);
  }
} 