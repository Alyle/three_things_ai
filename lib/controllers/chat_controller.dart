import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';

class ChatController extends GetxController {
  final AIService _aiService = AIService();
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final currentResponse = ''.obs;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 添加用户消息
    final userMessage = ChatMessage(
      content: content,
      isUser: true,
    );
    messages.add(userMessage);

    // 设置加载状态
    isLoading.value = true;
    currentResponse.value = '';

    // 添加AI响应消息占位
    final aiMessage = ChatMessage(
      content: '',
      isUser: false,
    );
    messages.add(aiMessage);

    try {
      // 获取AI响应流
      await for (final chunk in _aiService.getChatResponseStream(content)) {
        currentResponse.value += chunk;
        // 更新最后一条消息的内容
        messages.last.content = currentResponse.value;
        messages.refresh();
      }
    } catch (e) {
      // 更新错误消息
      messages.last.content = '抱歉，发生了一些错误，请稍后重试。';
      messages.refresh();
    } finally {
      isLoading.value = false;
      currentResponse.value = '';
    }
  }
} 