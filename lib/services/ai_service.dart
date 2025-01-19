import 'package:three_things_ai/core/config/prompt_config.dart';
import 'openai_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

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

  /// 发送消息并获取响应
  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final messages = _buildMessages(message);
      final response = await _openai.chatCompletion(messages);
      debugPrint('AI响应原始内容:\n $response');
      return jsonDecode(response);
    } catch (e) {
      debugPrint('AI服务错误: $e');
      rethrow;
    }
  }
} 