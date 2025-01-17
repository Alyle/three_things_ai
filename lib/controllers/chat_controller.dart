import 'package:get/get.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';

class ChatController extends GetxController {
  final AIService _aiService;
  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;

  ChatController(this._aiService);

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // 添加用户消息
    messages.add(ChatMessage(
      content: content,
      isUser: true,
    ));

    // 获取AI响应
    isLoading.value = true;
    try {
      final response = await _aiService.getChatResponse(content);
      messages.add(ChatMessage(
        content: response,
        isUser: false,
      ));
    } catch (e) {
      messages.add(ChatMessage(
        content: '抱歉，发生了错误，请稍后重试。',
        isUser: false,
      ));
    } finally {
      isLoading.value = false;
    }
  }
} 