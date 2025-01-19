import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../core/config/app_config.dart';
import 'dart:async';


/// OpenAI API服务
class OpenAIService {
  final _client = http.Client();
  
  /// 创建请求体
  Map<String, dynamic> _createRequestBody(List<Map<String, String>> messages, {bool stream = false}) {
    return {
      'model': AppConfig.api.model,
      'messages': messages,
      if (stream) 'stream': true,
    };
  }

  /// 创建请求头
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${AppConfig.api.apiKey}',
  };

  /// 获取聊天响应流
  Stream<String> getChatResponseStream(List<Map<String, String>> messages) async* {
    try {
      final request = http.Request('POST', Uri.parse('${AppConfig.api.baseUrl}/chat/completions'));
      request.headers.addAll(_headers);
      request.body = jsonEncode(_createRequestBody(messages, stream: true));

      final response = await _client.send(request);
      if (response.statusCode != 200) {
        throw Exception('API请求失败: ${response.statusCode}');
      }

      await for (final chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
        if (chunk.isEmpty || chunk == 'data: [DONE]') continue;
        
        if (chunk.startsWith('data: ')) {
          try {
            final data = jsonDecode(chunk.substring(6));
            final content = data['choices'][0]['delta']['content'];
            if (content != null) {
              yield content;
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

  /// 获取聊天完成响应
  Future<String> chatCompletion(List<Map<String, String>> messages) async {
    try {
      final response = await _client.post(
        Uri.parse('${AppConfig.api.baseUrl}/chat/completions'),
        headers: _headers,
        body: jsonEncode(_createRequestBody(messages)),
      );

      if (response.statusCode != 200) {
        throw Exception('API请求失败: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } catch (e) {
      debugPrint('OpenAI请求错误: $e');
      rethrow;
    }
  }
} 