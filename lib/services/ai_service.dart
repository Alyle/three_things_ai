import 'package:three_things_ai/core/config/prompt_config.dart';
import 'openai_service.dart';

/// AI服务
class AIService {
  final _openai = OpenAIService();


  /// 构建完整的消息列表
  List<Map<String, String>> _buildMessages(String content) {
    return [
      ...PromptConfig.getSystemMessage(),
      {'role': 'user', 'content': content}
    ];
  }

  /// 获取聊天响应流
  Stream<Map<String, dynamic>> getChatResponseStream(String content) async* {
    final startTime = DateTime.now();
    final messages = _buildMessages(content);
    
    await for (final content in _openai.getChatResponseStream(messages)) {
      yield {
        'content': content,
        'duration': DateTime.now().difference(startTime),
      };
    }
  }
} 