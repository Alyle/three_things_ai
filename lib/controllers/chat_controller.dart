import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../core/constants/app_constants.dart';

class ChatController extends GetxController {
  final AIService _aiService = AIService();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final currentResponse = ''.obs;
  final List<Map<String, dynamic>> _pendingResponses = [];

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final userMessage = ChatMessage(
      content: content,
      isUser: true,
    );
    messages.add(userMessage);

    isLoading.value = true;
    currentResponse.value = '';
    _pendingResponses.clear();

    final aiMessage = ChatMessage(
      content: '',
      isUser: false,
    );
    messages.add(aiMessage);

    try {
      String fullResponse = '';
      await for (final chunk in _aiService.getChatResponseStream(content)) {
        fullResponse += chunk;
        
        if (fullResponse.trim().startsWith('{') && fullResponse.trim().endsWith('}')) {
          try {
            final jsonResponse = jsonDecode(fullResponse);
            _pendingResponses.add(jsonResponse);
            
            // 合并所有响应
            String mergedContent = '';
            for (var response in _pendingResponses) {
              if (response['type'] == 'goal_query') {
                mergedContent += response['answer'] ?? '';
              } else if (response['type'] == 'goal_action') {
                mergedContent += response['confirmation']['message'] ?? '';
              }
              mergedContent += '\n';
            }
            
            currentResponse.value = mergedContent.trim();
            
            // 只在收到新的完整响应时显示提示
            Get.snackbar(
              '提示',
              '收到新的响应',
              duration: AppConstants.snackBarDuration,
              backgroundColor: Colors.blue[100],
              snackPosition: SnackPosition.TOP,
            );
          } catch (e) {
            currentResponse.value = fullResponse;
            Get.snackbar(
              '错误',
              'JSON解析失败',
              duration: AppConstants.snackBarDuration,
              backgroundColor: Colors.red[100],
              snackPosition: SnackPosition.TOP,
            );
          }
        } else {
          currentResponse.value = fullResponse;
        }
        
        messages.last.content = currentResponse.value;
        messages.refresh();
      }
    } catch (e) {
      messages.last.content = '抱歉，发生了一些错误，请稍后重试。';
      messages.refresh();
      Get.snackbar(
        '错误',
        '请求失败',
        duration: AppConstants.snackBarDuration,
        backgroundColor: Colors.red[100],
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
      currentResponse.value = '';
      _pendingResponses.clear();
    }
  }
} 