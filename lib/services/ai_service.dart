import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class AIService {
  static const String _baseUrl = String.fromEnvironment(
    'DIFY_API_URL',
    defaultValue: 'http://42.192.114.26:8088/v1',
  );
  
  static const String _apiKey = String.fromEnvironment(
    'DIFY_API_KEY',
    defaultValue: 'app-mq3fD1tCSUb1kHcZ3ENcX20T',
  );

  Stream<String> getChatResponseStream(String message) async* {
    if (_apiKey.isEmpty) {
      yield '请先配置Dify API密钥';
      return;
    }

    try {
      debugPrint('发送请求到: $_baseUrl/chat-messages');
      debugPrint('消息内容: $message');
      
      final request = http.Request('POST', Uri.parse('$_baseUrl/chat-messages'));
      request.headers.addAll({
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream',
      });
      
      request.body = jsonEncode({
        'inputs': {},
        'query': message,
        'response_mode': 'streaming',
        'conversation_id': '',
        'user': 'user',
      });

      final streamedResponse = await request.send();
      debugPrint('响应状态码: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200) {
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          for (final line in chunk.split('\n')) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data == '[DONE]') continue;
              
              try {
                final jsonData = jsonDecode(data);
                if (jsonData['answer'] != null) {
                  yield jsonData['answer'].toString();
                }
              } catch (e) {
                debugPrint('解析响应数据失败: $e');
              }
            }
          }
        }
      } else {
        final error = '请求失败: 状态码=${streamedResponse.statusCode}';
        debugPrint(error);
        yield error;
      }
    } catch (e, stackTrace) {
      final error = '网络错误: $e\n$stackTrace';
      debugPrint(error);
      yield error;
    }
  }
} 