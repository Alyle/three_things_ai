import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../core/config/app_config.dart';
import 'dart:async';
import '../core/config/prompt_config.dart';


/// OpenAI API服务
class OpenAIService {
  final _client = http.Client();
  
  /// 获取聊天响应流
  Stream<Map<String, dynamic>> getChatResponseStream(String content) async* {
    final startTime = DateTime.now();
    
    try {
      final request = http.Request('POST', Uri.parse('${AppConfig.api.baseUrl}/chat/completions'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.api.apiKey}',
      });
      
      request.body = jsonEncode({
        'model': AppConfig.api.model,
        'messages': [
          ...PromptConfig.getSystemMessage(),
          {'role': 'user', 'content': content}
        ],
        'stream': true,
      });

      final response = await _client.send(request);

      if (response.statusCode != 200) {
        throw Exception('API请求失败: ${response.statusCode}');
      }

      await for (final chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
        if (chunk.isEmpty) continue;
        if (chunk == 'data: [DONE]') break;
        
        if (chunk.startsWith('data: ')) {
          try {
            final data = jsonDecode(chunk.substring(6));
            final content = data['choices'][0]['delta']['content'];
            if (content != null) {
              yield {
                'content': content,
                'duration': DateTime.now().difference(startTime),
              };
            }
          } catch (e) {
            debugPrint('解析响应数据失败: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('获取AI响应失败: $e');
      throw Exception('获取AI响应失败');
    }
  }
} 